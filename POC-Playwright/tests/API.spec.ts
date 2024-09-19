import { expect, request, test } from '@playwright/test'
import * as fs from 'fs';
test.describe('POST Request', () => {
    test('should be able to create a booking', async ({ request }) => {
        const response = await request.post("/booking", {
            data: {
                "firstname": "Dream",
                "lastname": "Soobin",
                "totalprice": 329,
                "depositpaid": true,
                "bookingdates": {
                    "checkin": "2023-06-01",
                    "checkout": "2023-06-15"
                },
                "additionalneeds": "Breakfast"
            }
        });
        console.log(await response.json());
        expect(response.ok()).toBeTruthy();
        expect(response.status()).toBe(200);
        const responseBody = await response.json()
        expect(responseBody.booking).toHaveProperty("firstname", "Dream");
        expect(responseBody.booking).toHaveProperty("lastname", "Soobin");
        expect(responseBody.booking).toHaveProperty("totalprice", 329);
        expect(responseBody.booking).toHaveProperty("depositpaid", true);

    });

    test('should be able to create a booking option 2', async ({ request }) => {
        const bookingData = {
            "firstname": "Dream",
            "lastname": "Soobin",
            "totalprice": 213,
            "depositpaid": true,
            "bookingdates": {
                "checkin": "2023-06-01",
                "checkout": "2023-06-15"
            },
            "additionalneeds": "Breakfast"
        };

        const response = await request.post("/booking", {
            data: bookingData
        });

        const responseData = await response.json();
        console.log('Response Data:', responseData);
        console.log('Expected Firstname:', bookingData.firstname);
        console.log('Actual Firstname:', responseData.firstname);
        // Assertions
        expect(response.ok()).toBeTruthy();
        expect(response.status()).toBe(200);

        // // Verify the response data matches the booking data
        // expect(responseData.firstname).toBe(bookingData.firstname);
        // expect(responseData.lastname).toBe(bookingData.lastname);
        // expect(responseData.totalprice).toBe(bookingData.totalprice);
        // expect(responseData.depositpaid).toBe(bookingData.depositpaid);
        // expect(responseData.bookingdates.checkin).toBe(bookingData.bookingdates.checkin);
        // expect(responseData.bookingdates.checkout).toBe(bookingData.bookingdates.checkout);
        // expect(responseData.additionalneeds).toBe(bookingData.additionalneeds);
        // Check if the response data has the expected properties
        expect(responseData.booking).toHaveProperty('firstname', bookingData.firstname);
        expect(responseData.booking).toHaveProperty('lastname', bookingData.lastname);
        expect(responseData.booking).toHaveProperty('totalprice', bookingData.totalprice);
        expect(responseData.booking).toHaveProperty('depositpaid', bookingData.depositpaid);
        expect(responseData.booking.bookingdates).toHaveProperty('checkin', bookingData.bookingdates.checkin);
        expect(responseData.booking.bookingdates).toHaveProperty('checkout', bookingData.bookingdates.checkout);
        expect(responseData.booking).toHaveProperty('additionalneeds', bookingData.additionalneeds);
    });
    test('try', async ({ }) => {
        try {
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

            const responseBody = await response.json();
            console.log(responseBody);
            // Log the return_result array
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
});

test.describe('GET request', () => {
    test('should be get all the booking details', async ({ request }) => {
        const response = await request.get('/booking');
        console.log(await response.json());
        expect(response.ok()).toBeTruthy();
        expect(response.status()).toBe(200);
    });

    test('should be able to get subset of booking details using query parameters', async ({ request }) => {
        const response = await request.get('https://restful-booker.herokuapp.com/booking', {
            params: {

                firstname: "Dream",
                lastname: "Soobin"

            },
        });
        console.log(await response.json());
        expect(response.ok()).toBeTruthy();
        expect(response.status()).toBe(200);
    });

    test('should be able to get subset of booking details using query parameters - checkin date example', async ({ request }) => {
        const response = await request.get('/booking', {
            params: {
                checkin: "2021-01-15",
                checkout: "2023-03-25"

            },
        });
        const data = await response.json();
        console.log(data);
        expect(response.ok()).toBeTruthy();
        expect(response.status()).toBe(200);
    });

    test('view data with booking id', async ({ request }) => {
        // Extract the booking ID from the response
        const bookingId = 2;

        try {
            // GET request to retrieve the booking details
            const getResponse = await request.get(`/booking/${bookingId}`);

            // Check if the response is OK
            if (!getResponse.ok) {
                throw new Error(`Failed to fetch booking details: ${getResponse.statusText}`);
            }

            const getData = await getResponse.json();
            console.log('Booking Details:', getData);

            // Assertions
            console.log('GET Response by ID Status:', getResponse.status);
            console.log('GET Response by ID OK:', getResponse.ok);
            expect(getResponse.ok).toBeTruthy();
            expect(getResponse.status).toBe(200);
        } catch (error) {
            console.error('Error fetching booking details:', error);
        }
    });


    test('view data with all each', async ({ request }) => {

        // POST request to create a new booking

        const postResponse = await request.post("/booking", {
            data: {
                "firstname": "Dream",
                "lastname": "Soobin",
                "totalprice": 329,
                "depositpaid": true,
                "bookingdates": {
                    "checkin": "2024-06-01",
                    "checkout": "2024-06-15"
                },
                "additionalneeds": "Breakfast"
            }
        });


        const postData = await postResponse.json();
        console.log('Booking Created:', postData);

        // Extract the booking ID from the response
        const bookingId = postData.bookingid;

        // GET request to retrieve the booking details by ID
        const getResponseById = await request.get(`https://restful-booker.herokuapp.com/booking/${bookingId}`);
        const getDataById = await getResponseById.json();
        console.log('Booking Details by ID:', getDataById);

        // GET request to retrieve bookings by firstname
        const getResponseByFirstname = await request.get('https://restful-booker.herokuapp.com/booking', {
            params: { firstname: "Dream" }
        });
        const getDataByFirstname = await getResponseByFirstname.json();
        console.log('Bookings by Firstname:', getDataByFirstname);

        // GET request to retrieve bookings by lastname
        const getResponseByLastname = await request.get('https://restful-booker.herokuapp.com/booking', {
            params: { lastname: "Soobin" }
        });
        const getDataByLastname = await getResponseByLastname.json();
        console.log('Bookings by Lastname:', getDataByLastname);

        // GET request to retrieve bookings by totalprice
        const getResponseByTotalprice = await request.get('https://restful-booker.herokuapp.com/booking', {
            params: { totalprice: 329 }
        });
        const getDataByTotalprice = await getResponseByTotalprice.json();
        console.log('Bookings by Totalprice:', getDataByTotalprice);

        // GET request to retrieve bookings by bookingdates
        const getResponseByBookingdates = await request.get('https://restful-booker.herokuapp.com/booking', {
            params: {
                checkin: "2023-06-01",
                checkout: "2023-06-15"
            }
        });
        const getDataByBookingdates = await getResponseByBookingdates.json();
        console.log('Bookings by Booking Dates:', getDataByBookingdates);

        // Assertions with additional logging
        console.log('POST Response Status:', postResponse.status);
        console.log('POST Response OK:', postResponse.ok);
        expect(postResponse.ok).toBeTruthy();
        expect(postResponse.status).toBe(200);

        console.log('GET Response by ID Status:', getResponseById.status);
        console.log('GET Response by ID OK:', getResponseById.ok);
        expect(getResponseById.ok).toBeTruthy();
        expect(getResponseById.status).toBe(200);

        console.log('GET Response by Firstname Status:', getResponseByFirstname.status);
        console.log('GET Response by Firstname OK:', getResponseByFirstname.ok);
        expect(getResponseByFirstname.ok).toBeTruthy();
        expect(getResponseByFirstname.status).toBe(200);

        console.log('GET Response by Lastname Status:', getResponseByLastname.status);
        console.log('GET Response by Lastname OK:', getResponseByLastname.ok);
        expect(getResponseByLastname.ok).toBeTruthy();
        expect(getResponseByLastname.status).toBe(200);

        console.log('GET Response by Totalprice Status:', getResponseByTotalprice.status);
        console.log('GET Response by Totalprice OK:', getResponseByTotalprice.ok);
        expect(getResponseByTotalprice.ok).toBeTruthy();
        expect(getResponseByTotalprice.status).toBe(200);

        console.log('GET Response by Booking Dates Status:', getResponseByBookingdates.status);
        console.log('GET Response by Booking Dates OK:', getResponseByBookingdates.ok);
        expect(getResponseByBookingdates.ok).toBeTruthy();
        expect(getResponseByBookingdates.status).toBe(200);
    });

});