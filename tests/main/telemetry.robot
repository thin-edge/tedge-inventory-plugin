*** Settings ***
Resource    ../resources/common.robot
Library    Cumulocity
Library    DeviceLibrary

Suite Setup    Custom Setup

*** Test Cases ***

Inventory Script: OS information
    ${mo}=    Cumulocity.Device Should Have Fragments    device_OS    timeout=90
    Log    ${mo["device_OS"]}
    Should Not Be Empty    ${mo["device_OS"]["arch"]}
    Should Not Be Empty    ${mo["device_OS"]["displayName"]}
    Should Not Be Empty    ${mo["device_OS"]["family"]}
    Should Not Be Empty    ${mo["device_OS"]["hostname"]}
    Should Not Be Empty    ${mo["device_OS"]["kernel"]}
    Should Not Be Empty    ${mo["device_OS"]["version"]}

Inventory Script: Hardware information
    ${mo}=    Cumulocity.Device Should Have Fragments    c8y_Hardware    timeout=90
    Log    ${mo["c8y_Hardware"]}
    Should Not Be Empty    ${mo["c8y_Hardware"]["model"]}
    Should Not Be Empty    ${mo["c8y_Hardware"]["serialNumber"]}
    Should Not Start With    ${mo["c8y_Hardware"]["serialNumber"]}    -
    Should Not Be Empty    ${mo["c8y_Hardware"]["revision"]}

Inventory Script: Position information
    ${mo}=    Cumulocity.Device Should Have Fragments    c8y_Position    timeout=90
    Log    ${mo["c8y_Position"]}
    Should Not Be Empty    ${mo["c8y_Position"]["ip"]}
    Should Not Be Empty    ${mo["c8y_Position"]["city"]}
    Should Not Be Empty    ${mo["c8y_Position"]["country"]}
    Should Not Be Empty    ${mo["c8y_Position"]["timezone"]}

    Should Be True    ${mo["c8y_Position"]["lat"]} != 0
    Should Be True    ${mo["c8y_Position"]["lng"]} != 0

Inventory Script: Device Certificate information
    ${mo}=    Cumulocity.Device Should Have Fragments    device_Certificate    timeout=90
    Log    ${mo["device_Certificate"]}
    Should Not Be Empty    ${mo["device_Certificate"]["issuer"]}
    Should Not Be Empty    ${mo["device_Certificate"]["subject"]}
    Should Not Be Empty    ${mo["device_Certificate"]["thumbprint"]}
    Should Not Be Empty    ${mo["device_Certificate"]["signedBy"]}
    Should Not Be Empty    ${mo["device_Certificate"]["validFrom"]}
    Should Not Be Empty    ${mo["device_Certificate"]["validUntil"]}

*** Keywords ***

Custom Setup
    Set Main Device
