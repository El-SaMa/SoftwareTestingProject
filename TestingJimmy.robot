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

Search For Product, Open First Result And Check Page
    [Arguments]  ${product_name}  ${keyword}
    Input Text  id:searchinput  ${product_name}
    Press Keys  id:searchinput  ENTER
    Sleep  1s
    ${first_product_link}=  Get WebElement  xpath://html/body/main/div[2]/div/div[2]/div[5]/div/div[1]/product-box/div[2]
    Sleep  1s
    Capture Element Screenshot  ${first_product_link}  filename=first_product.png
    Click Element  ${first_product_link}
    Page Should Contain  ps5




######################################################################################Test Caases###################
# Mandatory 5 Test Cases 
#Does all product categories have a "landing page"
# Test search feature from main page (search keyword is: ps5)
        #robot takes element screenshot from first product
        #robot drills down to product page
        #robot checks that there is something in product page what matches to keyword what was used in search
# Can you find link "Lisää koriin" from product page
# Can you find icon related to link "Lisää koriin". Robot takes element screenshot from icon.
# Robot adds product into shopping cart
*** Test Cases ***
TC_UI_1 Verify All Product Categories Have a Landing Page
    [Tags]    Medium
    [Documentation]    Verify if all product categories have a "landing page".
    [Setup]    Navigate To Main Page

    ${category_count}=  Get Element Count  xpath://*[@id="sitemegamenu"]/nav/ul/li/a     #Count the number of category links.
    FOR  ${index}  IN RANGE  1  ${category_count}     #Loop through each category, ignoring 'Kampanjat'.
        ${category_xpath}=  Set Variable  xpath:(//*[@id="sitemegamenu"]/nav/ul/li/a)[${index}]
        ${category_text}=  Get Text  ${category_xpath}
        Run Keyword If  '${category_text}' == 'Kampanjat'  Continue For Loop
        Verify Category Landing Page  ${category_xpath}
    END
TC_UI_2 Verify Product Search And Details
    [Tags]  Medium
    [Documentation]  Test search feature from main page (search keyword is: ps5).
    [Setup]  Navigate To Main Page
    Search For Product, Open First Result And Check Page  ps5  ps5



############################
# Extra 5 Test Cases:
    # Verify Product Listings on Category Page
    #
    #
    #
    #
    
TC_UI_6 Verify Product Listings on Category Page
    [Tags]    Medium
    [Documentation]    Verify if each product on the category page has a title, price, and an "Add to Cart" button.
    [Setup]    Navigate To Main Page
    # Note: This assumes you've already navigated to a specific category page. Adjust as needed.
    ${product_count}=    Get Element Count    xpath://*[@class='product-list-item']
    FOR    ${index}    IN RANGE    1  ${product_count}
    ${product_xpath}=    Set Variable    xpath:(//*[@class='product-list-item'])[${index}]
    Verify Product Listing    ${product_xpath}
    END

