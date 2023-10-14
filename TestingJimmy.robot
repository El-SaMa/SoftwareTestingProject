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


Verify Product Listing
    [Arguments]    ${product_xpath}
    Wait Until Page Contains Element    ${product_xpath}
    ${title_exists}=    Run Keyword And Return Status    Element Should Be Visible    ${product_xpath}//h2[@class='product-title']
    ${price_exists}=    Run Keyword And Return Status    Element Should Be Visible    ${product_xpath}//span[@class='price']
    ${add_to_cart_exists}=    Run Keyword And Return Status    Element Should Be Visible    ${product_xpath}//button[contains(text(), 'Add to Cart')]
    Should Be True    ${title_exists}
    Should Be True    ${price_exists}
    Should Be True    ${add_to_cart_exists}

*** Test Cases ***

TC_UI_1 Verify All Product Categories Have a Landing Page
    [Tags]    Medium
    [Documentation]    Verify if all product categories have a "landing page".
    [Setup]    Navigate To Main Page

    ${category_count}=  Get Element Count  xpath://*[@id="sitemegamenu"]/nav/ul/li/a
    FOR  ${index}  IN RANGE  1  ${category_count}+1
        ${category_xpath}=  Set Variable  xpath:(//*[@id="sitemegamenu"]/nav/ul/li/a)[${index}]
        ${category_text}=  Get Text  ${category_xpath}
        Run Keyword If  '${category_text}' == 'Kampanjat'  Continue For Loop
        Verify Category Landing Page  ${category_xpath}
    END

TC_UI_2 Verify Product Listings on Category Page
    [Tags]    Medium
    [Documentation]    Verify if each product on the category page has a title, price, and an "Add to Cart" button.
    [Setup]    Navigate To Main Page
    # Note: This assumes you've already navigated to a specific category page. Adjust as needed.
    ${products}=    Get WebElements    xpath://*[@class='product-list-item']
    FOR    ${product}    IN    @{products}
        Verify Product Listing    ${product}
    END
