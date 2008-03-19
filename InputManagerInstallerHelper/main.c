//  Multiclutch is made available for use under the BSD license.

#include <Security/Authorization.h>
#include <Security/AuthorizationTags.h>
#include <mach-o/dyld.h>
#include <sys/param.h>
#include <stdlib.h>
#include <string.h>
AuthorizationRef myAuthorizationRef = 0;
OSStatus myStatus;

//inspired by http://developer.apple.com/documentation/Security/Conceptual/authorization_concepts/03authtasks/chapter_3_section_4.html#//apple_ref/doc/uid/TP30000995-CH206-TPXREF33

int main() {
	AuthorizationFlags myFlags = kAuthorizationFlagDefaults;
	
    do
    {
        {
			AuthorizationItem myItems[] = {
				{kAuthorizationRightExecute, 
				strlen("/bin/sh"), "/bin/sh", 0}};
			AuthorizationRights myRights = {
			sizeof(myItems)/sizeof(AuthorizationItem), myItems };	
			myStatus = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment,
										   myFlags, &myAuthorizationRef);		
			myFlags =   kAuthorizationFlagDefaults |
			kAuthorizationFlagInteractionAllowed |
			
			kAuthorizationFlagPreAuthorize |
			kAuthorizationFlagExtendRights;
			myStatus = AuthorizationCopyRights (myAuthorizationRef,&myRights, NULL, myFlags, NULL );
        }
		
        if (myStatus != errAuthorizationSuccess) break;
		
        {
			char mypath[MAXPATHLEN];
			uint32_t mypath_size= sizeof(mypath);
			_NSGetExecutablePath(mypath, &mypath_size);
			if (myStatus != errAuthorizationSuccess)
				return myStatus;
			
			char *myapp = ".sh";
			
			strcat(mypath, myapp);
			
            char *myArguments[] = {mypath, NULL };
            FILE *myCommunicationsPipe = NULL;
            char myReadBuffer[128];
			
            myFlags = kAuthorizationFlagDefaults;
            myStatus = AuthorizationExecuteWithPrivileges
			(myAuthorizationRef, "/bin/sh", myFlags, myArguments,
			 &myCommunicationsPipe);
			
            if (myStatus == errAuthorizationSuccess)
                for(;;)
                {
                    int bytesRead = read (fileno (myCommunicationsPipe),
										  myReadBuffer, sizeof (myReadBuffer));
                    if (bytesRead < 1) break;
					write (fileno (stdout), myReadBuffer, bytesRead);
                }
        }
    } while (0);
	
    AuthorizationFree (myAuthorizationRef, kAuthorizationFlagDefaults);
	
    if (myStatus) printf("Status: %ld\n", myStatus);
    return myStatus;
}