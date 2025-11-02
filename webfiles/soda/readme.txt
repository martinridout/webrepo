
1. Prerequisites for Deployment 

* Verify the MATLAB Compiler Runtime (MCR) is installed and ensure you    
  have installed version 7.10.   

* If the MCR is not installed, run MCRInstaller


2. Files for Standalone 
================================
-SODA_v0.ctf (component technology file)
-SODA_v0.exe
-MCRInstaller.exe 
-This read-me file 

3. Definitions

MCR - MATLAB Compiler uses the MATLAB Compiler Runtime (MCR), 
which is a standalone set of shared libraries that enable the execution 
of M-files. The MCR provides complete support for all features of 
MATLAB without the MATLAB GUI. If necessary, run MCRInstaller to install 
the correct version of the MCR.

Component Technology File (CTF) - Archive of encrypted MATLAB files that 
SODA_v0 uses for successful execution of exported M functions. 


4. Appendix 

A. On the target machine, add the MCR directory to the system path    
   specified by the target system's environment variable. 


    i. Locate the name of the environment variable to set, using the  
       table below:

    Operating System        Environment Variable
    ================        ====================
    Windows                 PATH


     ii. Set the path by doing one of the following:

        NOTE: <mcr_root> is the directory where MCR is installed
              on the target machine.         

        On Windows systems:

        * Add the MCR directory to the environment variable by opening 
        a command prompt and issuing the DOS command:

            set PATH=<mcr_root>\v710\runtime\win32;%PATH% 

        Alternately, for Windows, add the following pathname:
            <mcr_root>\v710\runtime\win32
        to the PATH environment variable, by doing the following:
            1. Select the My Computer icon on your desktop.
            2. Right-click the icon and select Properties from the menu.
            3. Select the Advanced tab.
            4. Click Environment Variables.  



        NOTE: On Windows, the environment variable syntax utilizes 
              backslashes (\), delimited by semi-colons (;). 
