echo off
echo �������ڡ�������Ӧ�ö�����豸���и��ġ� ��ѡ���ǡ��Ի�ȡ����ԱȨ�������б���װ�ű�
echo Pop up window "allow this app to make changes to your device" please select "yes" to obtain administrator rights to run this installation script
echo.

::��ȡ����ԱȨ��
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
::���ֵ�ǰĿ¼������
cd /d "%~dp0"

echo off
echo ��ʼ���а�װ�ű�����װ����ǰ��ȷ�����������ѹرջ��ĵ��ѱ���
echo Start running the installation script. Before installing the driver, make sure that other programs have been closed or the document has been saved.
echo.


::�����ӳٱ�����չ
setlocal enabledelayedexpansion
echo.

 ::ɾ����ʷ�����ļ�
 if exist hid_dev.txt (
    del/f /q hid_dev.txt
)
echo.

::ɾ����ʷ��¼�ļ�
if exist Return_InstDrv.txt (
    del/f /q Return_InstDrv.txt
)
echo.

echo ��ʼ�������е�HID�豸device
pnputil /scan-devices
echo scan-devicesɨ���豸ok
echo.
pnputil /enum-devices /connected /class {745a17a0-74d3-11d0-b6fe-00a0c90f57da}  /ids /relations >hid_dev.txt
echo enum-devicesö���豸ok
echo.

::����Ƿ��ҵ�΢��ACPI\MSFT0001��׼Ӳ��ID��touchpad���ذ��豸ACPI\VEN_MSFT&DEV_0001
find/i "ACPI\MSFT0001" hid_dev.txt || (
     echo δ���ִ��ذ��豸��
     echo No TouchPad device found. 
     echo.
     echo NotFoundTP >Return_InstDrv.txt
     exit
)

echo �ҵ�touchpad���ذ��豸
echo TouchPad device found.
echo ACPI\MSFT0001 >MSFT0001_FOUND.txt
echo.

 ::��װ���������ӵ��������в��Ұ�װ
  pnputil /add-driver MouseLikeTouchPad_I2C.inf /install
  echo add-driver��װ����ok
  echo.
  

 :ɨ��i2c���ذ��豸
pnputil /scan-devices
echo scan-devicesɨ���豸ok
echo.

::��֤�Ƿ�װ�ɹ���ע���/connected��ʾ�Ѿ�����
pnputil /enum-devices /connected /class {745a17a0-74d3-11d0-b6fe-00a0c90f57da}  /ids /relations >hid_dev.txt
echo enum-devicesö���豸ok
echo.
 
find/i "MouseLikeTouchPad_I2C" hid_dev.txt || (
     echo ��װ����ʧ�ܣ����Ժ�����
     echo Failed to install the driver. Please  try again later.
     echo.
     echo INSTDRV_FAILED >Return_InstDrv.txt
     del/f /q hid_dev.txt
     exit
)

del/f /q hid_dev.txt
echo.

echo ��װ�����ɹ�
echo Driver installed successfully.
echo.
echo INSTDRV_OK >Return_InstDrv.txt
echo INSTDRV_OK >InstDrvSuccess.txt
echo.
