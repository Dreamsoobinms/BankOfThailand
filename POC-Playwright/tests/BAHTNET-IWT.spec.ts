
import { test, expect, chromium, BrowserContext, request, Page } from '@playwright/test';
import { exec } from 'child_process';
import * as fs from 'fs';
import path from 'path';


test('5.1.3 Reguent แบบ มี Certificate ดึงข้อมูลได้ถูกต้อง', async ({ }) => {
    try {
        // This block creates a new context for the request, setting up necessary headers and client certificates.
        const context = await request.newContext({
            ignoreHTTPSErrors: true,
            extraHTTPHeaders: {
                'Content-Type': 'application/json',
                'accept': 'application/json',
                'X-IBM-Client-Id': 'a7f05458-6cc3-45bd-b912-f974218d9277',
                'X-IBM-Client-Secret': 'C8jN8tM4tU5rS5qK2nX4jR0dR5bG4cQ6aH5uF3rU5fK1sW0dN0',
                'Host': 'apixgw2.bot.or.th'
            },
            clientCertificates: [
                {
                    origin: 'https://apixgw2.bot.or.th',
                    pfxPath: 'C:\\Users\\AtiwitK\\Documents\\Postman\\DDG-2.pfx',
                    passphrase: '1234zZ'
                }
            ]
        });

        // This block sends a POST request to the specified URL with the given headers and data.
        const response = await context.post('https://apixgw2.bot.or.th/bot-iwt/partner-extranet/bnapi/inquiry-status-tracking', {
            headers: {
                'Content-Type': 'application/json',
                'accept': 'application/json',
                'X-IBM-Client-Id': 'a7f05458-6cc3-45bd-b912-f974218d9277',
                'X-IBM-Client-Secret': 'C8jN8tM4tU5rS5qK2nX4jR0dR5bG4cQ6aH5uF3rU5fK1sW0dN0',
                'Host': 'apixgw2.bot.or.th'
            },
            data: {
                "inquiry_request": {
                    "credit_bic": "BOTHTHB1DDG",
                    "settlement_date": "2024-08-01"
                }
            }
        });

        // This block verifies that the response contains the expected properties and values
        const responseBody = await response.json();
        console.log(responseBody);
        // Log the return_result array
        // JSON.stringify(value): Converts the object to a JSON string.
        // JSON.stringify(value, replacer): Uses a replacer function or array to filter properties.
        // JSON.stringify(value, replacer, space): Adds indentation to the JSON string for readability.
        console.log(JSON.stringify(responseBody, null, 2));
        // Assertions to verify the output
        expect(responseBody).toHaveProperty('inquiry_response');
        expect(responseBody.inquiry_response).toHaveProperty('response_code', 'S');
        expect(responseBody.inquiry_response).toHaveProperty('reason', 'Success');
        expect(responseBody.inquiry_response).toHaveProperty('return_result');
        expect(responseBody.inquiry_response.return_result[0]).toMatchObject({
            settlement_datetime: "2024-08-02T09:33:16",
            sender_ref_debit: "MXSE61327181",
            message_type: "009",
            business_type: "RGS",
            debit_bic: "KASITHBK",
            debit_account: "0010037969",
            credit_bic: "BOTHTHB1DDG",
            credit_account: "0010039627",
            debtor_account: "0010037969",
            creditor_account: "0010039627",
            settlement_amount: "955214.41",
            transaction_status: "E",
            error_code: "MS716",
            outgoing_incoming: "I"
        });
    } catch (error) {
        console.error('Error:', error);
    }
});

test('5.1.3 Reguent แบบไม่มี Certificateสามารถเรียก API เพื่อดึงข้อมูลได้ถูกต้อง', async ({ }) => {
    const start_period = '2023-01-01';
    const end_period = '2023-12-31';
    const rate_type = 'some_rate_type';

    const url = `https://apigw1.bot.or.th/bot-iwt/partner-nc/Stat-ThaiBahtImpliedInterestRate/v2/THB_IMPL_INT_RATE/?start_period=${start_period}&end_period=${end_period}&rate_type=${rate_type}`;

    const headers = {
        'X-IBM-Client-Id': 'your_client_id',
        'X-IBM-Client-Secret': 'your_client_secret',
        'accept': 'application/json'
    };

    const context = await request.newContext({
        ignoreHTTPSErrors: true,
        extraHTTPHeaders: headers
    });

    const response = await context.get(url);
    expect(response.ok()).toBeTruthy();
    const data = await response.json();
    console.log(data);
});

test('GET request with headers and parameters', async ({ request }) => {
    const start_period = '2023-01-01';
    const end_period = '2023-12-31';
    const rate_type = 'some_rate_type';
  
    const url = `https://apigw1.bot.or.th/bot-iwt/partner-nc/Stat-ThaiBahtImpliedInterestRate/v2/THB_IMPL_INT_RATE/?start_period=${start_period}&end_period=${end_period}&rate_type=${rate_type}`;
  
    const headers = {
      'X-IBM-Client-Id': 'your_client_id',
      'X-IBM-Client-Secret': 'your_client_secret',
      'accept': 'application/json'
    };
  
    const response = await request.get(url, { headers });
    expect(response.ok()).toBeTruthy();
    const data = await response.json();
    console.log(data);
  });

test('5.1.4 การใช้ Certificate ในการ Login', async ({ }) => {

    // Customer-specific details
    const customerProfile = {
        p12Path: 'C:\\Users\\AtiwitK\\Downloads\\SCB-1.p12', // Path to customer's .p12 file
        passphrase: '1234zZ', // Passphrase for the .p12 file
        origin: 'https://bahtnet-iwt.xtest-bot.or.th', // Origin URL for the login
    };

    console.log(`Using certificate path: ${customerProfile.p12Path}`);

    // Launch browser with a user profile
    const browser = await chromium.launchPersistentContext('C:\\Users\\AtiwitK\\AppData\\Local\\Google\\Chrome\\User Data\\Default', {
        ignoreHTTPSErrors: true, // Ignore HTTPS errors
        args: [
            '--ignore-certificate-errors', // Ignore certificate errors
            '--allow-running-insecure-content', // Allow running insecure content
            '--disable-web-security', // Disable web security
            '--enable-logging', // Enable logging
            '--v=1' // Set logging verbosity to 1
        ],
        clientCertificates: [
            {
                origin: customerProfile.origin, // URL that requires the client certificate
                pfxPath: customerProfile.p12Path, // Path to the .p12 file
                passphrase: customerProfile.passphrase // Passphrase for the .p12 file
            }
        ],
    });
    // Create a new page in the browser context
    const page = await browser.newPage();
    await page.waitForTimeout(10000);
    // Navigate to the specified URL
    await page.goto(`${customerProfile.origin}/EFSExternalWebUI/faces/home.jsp`);
    // Handle the certificate selection dialog
    page.on('dialog', async dialog => {
        console.log(dialog.message());
        await dialog.accept(); // Accept the dialog
    });
    // Wait for 10 seconds to ensure the page loads completely
    await page.waitForTimeout(10000);
    console.log('Page loaded successfully');

    // Close the browser context
    await browser.close();
});

test('try1 5.1.4 การใช้ Certificate ในการ Login', async ({ }) => {
    const browser = await chromium.launch({ headless: false });
    const context: BrowserContext = await browser.newContext({
        ignoreHTTPSErrors: true,
    });

    const page: Page = await context.newPage();

    // Call the AutoIt script to handle the certificate selection
    exec('"C:\\Program Files (x86)\\AutoIt3\\SciTE\\select_certificate.exe"', (error, stdout) => {
        if (error) {
            console.error(`Error executing AutoIt script: ${error}`);
            return;
        }
        console.log(`AutoIt script output: ${stdout}`);
    });

    // Start navigation to the site
    await page.goto('https://bahtnet-iwt.xtest-bot.or.th/EFSExternalWebUI/faces/home.jsp');

    // Wait for a short period to allow the certificate selection to complete
    await page.waitForTimeout(5000); // Adjust the timeout as needed

    console.log('Navigation successful');
    await browser.close();



});
test('try2 5.1.4 การใช้ Certificate ในการ Login', async ({ }) => {
    // process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';
    test.setTimeout(60000);
    // set
    const context = await chromium.launchPersistentContext('C:\\Users\\AtiwitK\\AppData\\Local\\Google\\Chrome\\User Data\\Default', {
        headless: false,
        args: [
            '--ignore-certificate-errors',
            '--allow-running-insecure-content',
            '--disable-web-security',
            '--enable-logging',
            '--v=1'
        ],
        ignoreHTTPSErrors: true,
        clientCertificates: [
            {
                origin: 'https://bahtnet-iwt.xtest-bot.or.th',
                pfxPath: 'C:\\Users\\AtiwitK\\Downloads\\SCB-1.p12',
                passphrase: '1234zZ'
            }
        ]
    });

    const page = await context.newPage();

    await page.goto('https://bahtnet-iwt.xtest-bot.or.th/EFSExternalWebUI/faces/home.jsp');
    await page.waitForLoadState('networkidle');
    await page.waitForTimeout(10000);
});