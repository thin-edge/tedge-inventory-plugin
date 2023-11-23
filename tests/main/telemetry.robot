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
    Should Not Be Empty    ${mo["c8y_Hardware"]["revision"]}

*** Keywords ***

Custom Setup
    Set Main Device
