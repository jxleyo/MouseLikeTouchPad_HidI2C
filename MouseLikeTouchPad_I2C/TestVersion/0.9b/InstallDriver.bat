echo off
echo �������ڡ�������Ӧ�ö�����豸���и��ġ� ��ѡ���ǡ��Ի�ȡ����ԱȨ�������б���װ�ű�
echo Pop up window "allow this app to make changes to your device" please select "yes" to obtain administrator rights to run this installation script
pause
echo.

::��ȡ����ԱȨ��
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
::���ֵ�ǰĿ¼������
cd /d "%~dp0"

echo off
echo ��ʼ���а�װ�ű�����װ����ǰ��ȷ�����������ѹرջ��ĵ��ѱ���
echo Start running the installation script. Before installing the driver, make sure that other programs have been closed or the document has been saved.
pause
echo.

echo ��ʼ��鰲װ�ļ�
echo Start checking installation files
echo.

if exist MouseLikeTouchPad_I2C.inf (
    echo MouseLikeTouchPad_I2C.inf�ļ�����
) else (
    echo MouseLikeTouchPad_I2C.inf�ļ���ʧ�����������������������װ��
    echo MouseLikeTouchPad_I2C.inf File Lost��Please check or download the driver installation package again.
    pause
    exit
)

if exist MouseLikeTouchPad_I2C.cat (
    echo MouseLikeTouchPad_I2C.cat�ļ�����
) else (
    echo MouseLikeTouchPad_I2C.cat�ļ���ʧ�����������������������װ��
    echo MouseLikeTouchPad_I2C.cat File Lost��Please check or download the driver installation package again.
    pause
    exit
)

if exist MouseLikeTouchPad_I2C.sys (
    echo MouseLikeTouchPad_I2C.sys�ļ�����
) else (
    echo MouseLikeTouchPad_I2C.sys�ļ���ʧ�����������������������װ��
    echo MouseLikeTouchPad_I2C.sys File Lost��Please check or download the driver installation package again.
    pause
    exit
)

if exist EVRootCA.reg (
    echo EVRootCA.reg�ļ�����
) else (
    echo EVRootCA.reg�ļ���ʧ�����������������������װ��
    echo EVRootCA.reg File Lost��Please check or download the driver installation package again.
    pause
    exit
)
echo.


::�����ӳٱ�����չ
setlocal enabledelayedexpansion
echo.

 ::ɾ����ʷ�����ļ�
del/f /q hid_dev.txt
del/f /q i2c_dev.txt
del/f /q dev*.tmp
del/f /q drv*.tmp
echo.

echo Check Windows Version..
ver>winver.txt
echo.

find "10.0." winver.txt || (
	 echo ��ǰϵͳ����windows10/11���޷���װ��
 	echo Current OS is not Windows10/11��Can't Install the Driver��
	 echo.
 	del/f /q winver.txt
 	echo.
	pause
 	exit
) 

 ::Win10 Build 19041.208(v2004)��ʽ�� //10.0.a.b��ʽ��ֱ���ж�a>=19041���ɣ�ע��delims��ѻس����з��Զ������ָ������Զ��������tokens����ֵ������Ҫ���㻻������µ��к�
 for /f "delims=[.] tokens=4" %%i in (winver.txt) do (
   set "winver=%%i"
 )
 
::��ֵ�ַ�����ֵ��С�Ƚϣ�ע����Ҫ���ţ�����ʵ���������ַ���λ����ͬʱ��С�Ƚϲ���׼ȷ�ģ�����2041��19041��Ƚϻ��Ǵ�����
if ("%winver%" LSS "19041") (
     echo ��ǰwindowsϵͳ�汾̫�ͣ�������������
	echo The current version of windows system is too low. Please upgrade and try again.
	echo.
	del/f /q winver.txt
	echo.
	pause
	exit
)

echo ��ǰwindowsϵͳ�汾ƥ��ok
echo Current Windows system version matches OK.
echo.

del/f /q winver.txt
echo.


echo ��ʼ�������е�HID�豸device
pnputil /scan-devices
echo scan-devicesɨ���豸ok
echo.
pnputil /enum-devices /connected /class {745a17a0-74d3-11d0-b6fe-00a0c90f57da}  /ids /relations >hid_dev.txt
echo enum-devicesö���豸ok
echo.

::����Ƿ��ҵ�touchpad���ذ��豸device
find/i "HID_DEVICE_UP:000D_U:0005" hid_dev.txt || (
     echo δ���ִ��ذ��豸����������˳����밲װԭ���������ٴγ���
     echo No TouchPad device found. Press any key to exit. Please install the original driver and try again.
     echo.
     pause
     exit
)

echo �ҵ�touchpad���ذ��豸
echo TouchPad device found.
echo.

echo ��ʼ����touchpad���ذ��Ӧ�ĸ���I2C�豸ʵ��InstanceID
echo.
 
 ::�滻�س����з�Ϊ���ŷ���ָע�����NUL����Ϊ׷��>>д��
for /f "delims=" %%i in (hid_dev.txt) do (
   set /p="%%i,"<nul>>dev0.tmp
 )

::�滻HID_DEVICE_UP:000D_U:0005Ϊ#����ָע��set /p��Ҫ�Ӷ���
for /f "delims=, tokens=*" %%i in (dev0.tmp) do (
    set "str=%%i"
    set "str=!str:HID_DEVICE_UP:000D_U:0005=#!"
    set /p="!str!,"<nul>>dev1.tmp
)

  ::��ȡ#�ָ���������ı���ע��set /p��Ҫ�Ӷ���
 for /f "delims=# tokens=2,*" %%i in (dev1.tmp) do (
   set /p="%%i,"<nul>>dev2.tmp
 )

  ::��ȡ:�ָ���������ı���ע��set /p��Ҫ�Ӷ���
 for /f "delims=: tokens=2" %%i in (dev2.tmp) do (
   set /p="%%i,"<nul>>dev3.tmp
 )

   ::��ȡ,�ָ���ǰ����ı�
 for /f "delims=, tokens=1" %%i in (dev3.tmp) do (
  set /p="%%i"<nul>>dev4.tmp
 )

    ::ɾ���ո�
 for /f "delims= " %%i in (dev4.tmp) do (
   set "str=%%i"
   echo !str!>i2c_dev_InstanceID.txt
 )
echo.

del/f /q hid_dev.txt
del/f /q dev*.tmp
echo.
 

 ::��֤InstanceID
  for /f "delims=" %%i in (i2c_dev_InstanceID.txt) do (
   set "i2c_dev_InstanceID=%%i"
   echo i2c_dev_InstanceID="!i2c_dev_InstanceID!"
   echo.
 )

 ::ע���/connected��ʾ�Ѿ�����
 pnputil /enum-devices /connected /instanceid "%i2c_dev_InstanceID%" /ids /relations /drivers >i2c_dev.txt
 echo.
 
 ::����Ƿ�Ϊi2c�豸device
find/i "ACPI\PNP0C50" i2c_dev.txt || (
     echo δ����i2c���ذ��豸���޷���װ����
     echo No I2C TouchPad device found, unable to install driver.
     echo.
     del/f /q i2c_dev.txt
     pause
     exit
)

echo �ҵ�i2c���ذ��豸
echo I2C TouchPad device found.
echo.
 
 
echo ��ʼ��װ��ǩ��֤��Reg import EVRootCA.reg
regedit /s EVRootCA.reg && (
    echo EVRootCA.reg��ǩ��֤�鰲װ���
) || (
     echo EVRootCA.regע����������󣬰�װʧ��
     echo EVRootCA.reg Registry operation error, installation failed.
     pause
     exit
)
echo.

echo ��ʼ��װ������
 ::��װ������ֻ���ӵ��������в���װ��ע�����һ����Ҫ��/install
 pnputil /add-driver MouseLikeTouchPad_I2C.inf
echo add-driver��װ����ok
echo.
  
 ::ɾ��i2c���ذ��豸
pnputil /remove-device "%i2c_dev_InstanceID%"
echo remove-deviceɾ���豸ok
echo.

 :ɨ��i2c���ذ��豸ʹ���Զ���װoem����������
pnputil /scan-devices
echo scan-devicesɨ���豸ok
echo.


::��֤�Ƿ�װ�ɹ���ע���/connected��ʾ�Ѿ�����
 pnputil /enum-devices /connected /instanceid "%i2c_dev_InstanceID%" /ids /relations /drivers >i2c_dev.txt
 echo.
 
find/i "MouseLikeTouchPad_I2C" i2c_dev.txt || (
     echo ��װ����ʧ�ܣ���ж�ص�������������������
     echo Failed to install the driver. Please uninstall the third-party driver and try again.
     echo.
     del/f /q i2c_dev.txt
     pause
     exit
)

del/f /q i2c_dev.txt
echo.

echo ��װ�����ɹ�
echo Driver installed successfully.
echo.

echo ����ѹһ�´��ذ尴���鿴�Ƿ������������������رձ�������ȡ������
echo Please press the touch pad button again to check whether it works normally. If it works normally, please close this window to cancel the restart
echo ������ذ岻�����밴������������Ժ󼴿�
echo If the touch pad does not work, press any key to restart the computer to complete the installation
pause

echo.

shutdown -r -f -t 0