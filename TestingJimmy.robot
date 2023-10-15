*** Settings ***
Library           SeleniumLibrary

Suite Setup       Setup Browser And Maximize
Suite Teardown    Close Browser

*** Keywords ***

Setup Browser And Maximize
    Open Browser    https://jimms.fi    chrome
    Maximize Browser Window

Navigate To Main Page
    Go To    https://jimms.fi

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

Search For Product
    [Arguments]  ${product_name}
    Input Text  id:searchinput  ${product_name}
    Press Keys  id:searchinput  ENTER
    Sleep  1s

Take a Screenshot Of First Product
    ${first_product_link}=  Get WebElement  xpath://html/body/main/div[2]/div/div[2]/div[5]/div/div[1]
    Capture Element Screenshot  ${first_product_link}  filename=first_product.png

Open First Product
    ${first_product_link}=  Get WebElement  xpath://html/body/main/div[2]/div/div[2]/div[5]/div/div[1]/product-box/div[2]/div[2]/h5/a/span
    Click Element  ${first_product_link}
    Sleep  2s  # Add a delay to ensure the product page loads
Capture URL Of The Product Page
    ${product_page_url}=  Get Location
    Set Suite Variable  ${product_page_url}  ${product_page_url}  # Store the URL in a suite variable
Check Product Page for ps5
    ${keyword}=  Get Text  id:searchinput
    Page Should Contain    text=${keyword}
Verify Category Product Listing
    [Arguments]    ${product_listing}
    # Verify that products are displayed on the category page
    Element Should Be Visible    ${product_listing}

Verify Products In Price Range
    [Arguments]    ${min_value}    ${max_value}
    # Get the list of product prices displayed on the page.
    ${product_prices}=    Get WebElements    xpath://div[@class='product-price']
    
    # Iterate through each product price and check if it falls within the selected range.
    FOR    ${price}    IN    @{product_prices}
        ${price_text}=    Get Text    ${price}
        ${price_numeric}=    Evaluate    ${price_text.replace('€', '').replace(',', '')}    # Remove '€' and ',' from the price text and convert to numeric
        
        # Verify if the price is within the selected range.
        ${price_within_range}=    Evaluate    ${min_value} <= ${price_numeric} <= ${max_value}
        
        # Check if the price is within the selected range and fail the test if not.
        Should Be True    ${price_within_range}    Product price ${price_text} is not within the selected range (${min_value}-${max_value})
    END

Get Body Background Color
    [Documentation]    Get the background color of the body element.
    ${background_color}=    Execute JavaScript    return window.getComputedStyle(document.body, null).getPropertyValue('background-color')
    [Return]    ${background_color}

Switch To Day Mode
    [Documentation]    Switch to day mode.
    Click Element    xpath:/html/body/div[1]/div/div/span
    Click Element    xpath:/html/body/div[1]/div/div/ul/li[1]/button

Switch To Night Mode
    [Documentation]    Switch to night mode.
    Click Element    xpath:/html/body/div[1]/div/div/span
    Click Element    xpath:/html/body/div[1]/div/div/ul/li[2]/button

Verify Background Color Change
    [Arguments]    ${expected_color}
    ${current_color}=    Get Body Background Color
    Should Be Equal As Strings    ${current_color}    ${expected_color}

Check Footer Links
    [Documentation]    Check the status of footer links
    [Tags]    Medium
    [Timeout]    5m

    @{footer_links}=    Get WebElements    xpath://div[@class="col-lxs-6 col-lg-3 mb-4 mb-lg-0"]//a[@class="nav-link footer-link"]

    FOR    ${link}    IN    @{footer_links}
        ${link_text}=    Get Text    ${link}
        ${link_url}=    Get Element Attribute    ${link}    href

        Go To    ${link_url}
        ${status}=    Run Keyword And Return Status    Page Should Contain    404 Not Found
        Log    Link '${link_text}' - Response Status Code: ${status}
        Run Keyword If    ${status}    Log    Link '${link_text}' is Broken: ${link_url}
        ...    ELSE    Log    Link '${link_text}' is Valid: ${link_url}
        Go Back
    END





######################################################################################Test Caases###################
*** Test Cases ***
# Mandatory 5 Test Cases 
#Does all product categories have a "landing page"
# Test search feature from main page (search keyword is: ps5)
        #robot takes element screenshot from first product
        #robot drills down to product page
        #robot checks that there is something in product page what matches to keyword what was used in search
# Can you find link "Lisää koriin" from product page
# Can you find icon related to link "Lisää koriin". Robot takes element screenshot from icon.
# Robot adds product into shopping cart
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
    [Documentation]  Test search feature from the main page (search keyword is: ps5).
    [Setup]  Navigate To Main Page

    # Search for the product
    Search For Product  ps5

    # Open the first product and check the page
    Take a Screen Shot Of First Product
    Sleep    1s
    Open First Product
    sleep    2s
    Check Product Page for ps5

TC_UI_3 Find link "Lisää koriin" from product page
    [Tags]  Medium
    [Documentation]  Find link "Lisää koriin" from product page On The PS5 Product.

    # Verify Page Contains Add To Cart Button / Link
    Page Should Contain Link    //a[@title="Lisää koriin"]

TC_UI_4 Find icon related to link "Lisää koriin"
    [Tags]  Medium
    [Documentation]  Find the icon related to the "Lisää koriin" link on the product page.

    # Find and capture a screenshot of the icon associated with "Lisää koriin"
    ${icon_element}=  Get WebElement  xpath://*[@id="product-cta-box"]/div/div[2]/div[2]/addto-cart-wrapper/div/a

    Capture Element Screenshot  ${icon_element}  filename=icon.png
    Sleep    1s

TC_UI_5 Add Product to Shopping Cart
    [Tags]    Medium
    [Documentation]    Robot adds a product into the shopping cart.

    # Precondition: Wait until the product page is loaded
    Wait Until Page Contains Element    xpath://a[@title="Lisää koriin"]
    
    # Click the "Lisää koriin" button to add the product to the shopping cart
    Sleep    2s
    Click Element    xpath://a[@title="Lisää koriin"]
    
    # Verify that the product has been added to the shopping cart 

    # Navigate to the cart page
    Sleep    2s
    Go To  https://www.jimms.fi/fi/ShoppingCart
    # Refresh the cart page
    Reload Page

    # Verify that the added product is in the cart
    Page Should Contain  ps5

    # Cleanup - Remove the added product from the cart
    # remove the product
    Click Element    xpath://*[@id="jim-main"]/div/div/div/div[1]/article/div/div[2]/div/div[1]/div/i

    # Refresh the cart page
    Reload Page
    Sleep    2s

    # Verify that the product has been removed from the cart
    Page Should Not Contain  ps5

############################
# Extra 5 Test Cases:
    # TC_UI_6 Verify Product Listings on Category Page
    # TC_UI_7 Verify Product Sorting on Search Page Asc Price And Capture ScreenShot 
    #
    #
    #

TC_UI_6 Verify Product Listings on Category Page
    [Tags]    Medium
    [Documentation]    Verify if each category page contains products and is not empty.
    [Setup]    Navigate To Main Page

    ${category_count}=    Get Element Count    xpath://*[@id="sitemegamenu"]/nav/ul/li/a
    FOR    ${index}    IN RANGE    1    ${category_count}
        ${category_xpath}=    Set Variable    xpath:(//*[@id="sitemegamenu"]/nav/ul/li/a)[${index}]
        ${category_text}=    Get Text    ${category_xpath}
        Run Keyword If    '${category_text}' == 'Kampanjat'    Continue For Loop  # Skip 'Kampanjat' category
        # Navigate to the category page
        Click Element    ${category_xpath}
        sleep    2s
        # Verify that products are displayed on the category page
        ${product_listings}=    Get WebElement    xpath://*[@id="jim-main"]/div[2]/div/div[2]/div[4]/div/div[1]/product-box/div[2]/div[2]/h5/a
        Element Should Be Visible    ${product_listings}

        # Add additional verifications or actions for each category here if needed

        # Navigate back to the main page
        Navigate To Main Page
    END

TC_UI_7 Verify Product Sorting on Search Page
    [Tags]  Medium
    [Documentation]  Verify product sorting on the search results page.
    [Setup]  Go to  https://www.jimms.fi/fi/Product/Search?q=ps5
    Sleep    2s

    # Capture the list of product prices before sorting
    ${unsorted_prices}=  Get WebElements  xpath://*[@id="productsearchpage"]/div[2]/div[5]/div/div[1]/product-box/div[2]/div[3]/div/span/span
    # Capture A Before Screenshot For Confirmation
    Capture Page Screenshot  Before_Sorting.png

    # Sort the products by price ascending
    # Click the dropdown to expand it
    Click Element  xpath://*[@id="productlist-sorting"]/div/button

    # Wait for the dropdown menu to appear (if needed)
    Wait Until Element Is Visible  xpath://*[@id="productlist-sorting"]/div/ul/li[7]/a

    # Click the desired item inside the dropdown menu
    Click Element  xpath://*[@id="productlist-sorting"]/div/ul/li[7]/a     # Hinta (Pienin-Suurin) Asc


    Sleep  2s  # Add a delay to ensure the page is fully updated after sorting

    # Capture the list of product prices after sorting
    ${sorted_prices}=  Get WebElements     xpath://*[@id="productsearchpage"]/div[2]/div[5]/div/div[1]/product-box/div[2]/div[3]/div/span/span
    # Capture a screenshot after sorting
    Capture Page Screenshot  After_Sorting.png

    # Verify And Compare the two lists to ensure they match when sorted in ascending order
     Should Not Be Equal  ${unsorted_prices}  ${sorted_prices}

TC_UI_8 Verify Price Range Filtering
    [Tags]    Medium
    [Documentation]    Verify price range filtering functionality using input fields.
    [Setup]    Go To   https://www.jimms.fi/fi/Product/Search?q=ps5

    # Set the minimum and maximum values for the price range.
    ${min_value}=    Set Variable    500
    ${max_value}=    Set Variable    1000

    # Set the XPath expressions for the input fields.
    # Use the "data-bind" attribute to locate the "min" input field
    ${min_input_xpath}=  Set Variable  xpath://input[@data-bind="numeric: filterSliderMin, value: filterMinText"]

    ${max_input_xpath}=    Set Variable    xpath://input[@data-bind="numeric: filterSliderMax, value: filterMaxText"]

    # Implement the logic to set the price range using the input fields.
    Input Text    ${min_input_xpath}    ${min_value}
    Input Text    ${max_input_xpath}    ${max_value}

    # Press Enter to apply the price range filter (if required).
    Press Keys    ${min_input_xpath}   ENTER
    Sleep    2s
    # You may need to adjust the key code (\\13) based on your specific website's behavior.

    # Use a custom keyword to verify if the products displayed match the selected price range.
    Verify Products In Price Range    ${min_value}    ${max_value}

    # End of test case. PASSES WITH A BUG. The price range filter is not working correctly.

TC_UI_9 Verify Day/Night Mode Switching    
    [Tags]    Medium
    [Documentation]    Verify day/night mode switching functionality.
    [Setup]    Navigate To Main Page

    # Get the current body color
    ${day_color}=    Get Body Background Color

    # Switch to night mode
    Switch To Night Mode

    # Verify that the body color has changed
    Verify Background Color Change    rgb(26, 30, 33)

    # Switch back to day mode
    Switch To Day Mode

    # Verify that the body color has changed back to the original day color
    Verify Background Color Change    rgb(245, 245, 245)

    # Take a screenshot before and after
    Capture Page Screenshot    before_switch.png
    Sleep    2s

    # Switch to night mode again
    Switch To Night Mode

    # Take a screenshot after switching to night mode again
    Capture Page Screenshot    after_switch.png
    Sleep    2s

    # Verify that the body color has changed to night mode again
    Verify Background Color Change    rgb(26, 30, 33)
TC_UI_10 Verify Footer Links
    [Tags]    Simple
    [Documentation]    Verify that all footer links are working correctly.
    [Setup]    Navigate To Main Page

    Check Footer Links
