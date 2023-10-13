*** Settings ***
Library  SeleniumLibrary

Suite Setup       Open Browser  http://jimms.fi  chrome
Suite Teardown    Close Browser

*** Variables ***
${SEARCH_KEYWORD}  ps5
${SEARCH_INPUT_LOCATOR}  id:search-input
${ADD_TO_CART_LINK_TEXT}  Lisää koriin

*** Test Cases ***

TC_UI_1 Verify All Product Categories Have a Landing Page
    [Tags]  Medium
    [Documentation]  Verify if all product categories have a "landing page".
    [Setup]  Navigate To Main Page
    # TODO: Implement the test steps

TC_UI_2 Test Search Feature Using Keyword PS5
    [Tags]  High
    [Documentation]  Test the search feature from the main page using keyword "ps5".
    [Setup]  Navigate To Main Page
    Input Text  ${SEARCH_INPUT_LOCATOR}  ${SEARCH_KEYWORD}
    Submit Form
    Capture Screenshot Of First Product
    Drill Down To Product Page
    Validate Content Matches Keyword  ${SEARCH_KEYWORD}

TC_UI_3 Verify Link Lisää Koriin Exists On Product Page
    [Tags]  High
    [Documentation]  Verify the existence of the "Lisää koriin" link on the product page.
    [Setup]  Navigate To Main Page
    # TODO: Implement navigation to a product page
    Page Should Contain Link  ${ADD_TO_CART_LINK_TEXT}

TC_UI_4 Capture Screenshot Of Link Lisää Koriin Icon
    [Tags]  Medium
    [Documentation]  Capture a screenshot of the icon related to the "Lisää koriin" link.
    [Setup]  Navigate To Main Page
    # TODO: Implement navigation to the location of the icon
    Capture Screenshot  Lisaa_koriin_icon.png

TC_UI_5 Add Product To Shopping Cart
    [Tags]  High
    [Documentation]  Add a product to the shopping cart.
    [Setup]  Navigate To Main Page
    # TODO: Implement the test steps

*** Keywords ***

Navigate To Main Page
    Go To  http://jimms.fi

Capture Screenshot Of First Product
    # TODO: Determine the appropriate selector
    ${first_product_locator}=  Set Variable  css:.first-product
    Capture Element Screenshot  ${first_product_locator}  first_product.png

Drill Down To Product Page
    # TODO: Determine the appropriate selector for the product link
    ${product_link_locator}=  Set Variable  css:.product-link
    Click Element  ${product_link_locator}

Validate Content Matches Keyword
    [Arguments]  ${keyword}
    Page Should Contain  ${keyword}
