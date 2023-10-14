*** Settings ***
Library           SeleniumLibrary

Suite Setup       Setup Browser And Maximize
Suite Teardown    Close Browser

*** Keywords ***

Setup Browser And Maximize
    Open Browser    http://jimms.fi    chrome
    Maximize Browser Window

Navigate To Main Page
    Go To    http://jimms.fi

Get List Of Categories
    ${categories}=    Get WebElements    xpath://*[@id="sitemegamenu"]/nav/ul/li/a
    [Return]    ${categories}

Verify Category Landing Page    [Arguments]    ${category_xpath}
    Scroll Element Into View    ${category_xpath}
    Click Element    ${category_xpath}
    Wait Until Page Contains Element    tag:h1
    Navigate To Main Page

*** Test Cases ***

TC_UI_1 Verify All Product Categories Have a Landing Page
    [Tags]    Medium
    [Documentation]    Verify if all product categories have a "landing page".
    [Setup]    Navigate To Main Page

    ${categories}=    Get List Of Categories
    ${category_count}=    Get Length    ${categories}
    FOR    ${index}    IN RANGE    1    ${category_count}+1
        ${category_xpath}=    Set Variable    xpath:(//*[@id="sitemegamenu"]/nav/ul/li/a)[${index}]
        Verify Category Landing Page    ${category_xpath}
    END
