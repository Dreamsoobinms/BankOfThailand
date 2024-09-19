import { test, expect, chromium, request } from '@playwright/test';
import fs from 'fs';
const ExcelJS = require('exceljs');
import pdfParse from 'pdf-parse';

test('5.1.1 การดึงข้อมูลตารางจาก Web ที่เป็นตาราง (in memory ,File)', async ({ page }) => {
    // !!!--- Go to Exchange rate and select desired date ---!!!
    const year = '2023'; // You can change this date or make it dynamic
    const month = '12'; // You can change this date or make it dynamic
    const day = '21'; // You can change this date or make it dynamic

    await page.goto('https://www.bot.or.th/th/statistics/exchange-rate.html');
    await page.getByRole('button', { name: 'ยอมรับการ ใช้งานคุกกี้ ที่จำเป็นเท่านั้น' }).click();
    await page.locator('input[type="date"]').fill(`${year}-${month}-${day}`);

    // !!!--- Extract table data from Exchange rate ---!!!
    // Wait for the table to load
    await page.waitForSelector('table');
    await page.waitForTimeout(5000);

    // Extract data from exchange rate
    const rawData = await page.evaluate(() => {
        const rows = Array.from(document.querySelectorAll('table tbody tr'));
        return rows.map(row => {
            const cells = Array.from(row.querySelectorAll('td'));
            return cells.map(cell => cell.innerText.trim());
        });
    });

    // Change extract data to datable with the same format by excel file
    const countries = rawData.slice(0, 19).map(row => row[0].split('\n\n'));
    const rates = rawData.slice(19, 38);
    const dataTable = [
        ['ประเทศ', 'สกุลเงิน', 'อัตราซื้อถัวเฉลี่ย ซื้อตั๋วเงิน', 'อัตราซื้อถัวเฉลี่ย ซื้อเงินโอน', 'อัตราขายถัวเฉลี่ย'],
        ...countries.map((country, index) => [
            country[1],
            country[0],
            rates[index][0],
            rates[index][1],
            rates[index][2]
        ])
    ];
    console.log(dataTable);

});

test('5.1.2 การดึงข้อมูลจาก เพื่อเปรียบเทียบความถูกต้อง (Excel , Doc)', async ({ page }) => {
    // !!!--- Go to Exchange rate and select desired date ---!!!
    const year = '2023'; // You can change this date or make it dynamic
    const month = '12'; // You can change this date or make it dynamic
    const day = '15'; // You can change this date or make it dynamic

    await page.goto('https://www.bot.or.th/th/statistics/exchange-rate.html');
    await page.getByRole('button', { name: 'ยอมรับการ ใช้งานคุกกี้ ที่จำเป็นเท่านั้น' }).click();
    await page.locator('input[type="date"]').fill(`${year}-${month}-${day}`);

    // !!!--- Extract table data from Exchange rate ---!!!
    // Wait for the table to load
    await page.waitForSelector('table');
    await page.waitForTimeout(4000);

    // Extract data from exchange rate
    const rawData = await page.evaluate(() => {
        const rows = Array.from(document.querySelectorAll('table tbody tr'));
        return rows.map(row => {
            const cells = Array.from(row.querySelectorAll('td'));
            return cells.map(cell => cell.innerText.trim());
        });
    });

    // Change extract data to datable with the same format by excel file
    const countries = rawData.slice(0, 19).map(row => row[0].split('\n\n'));
    const rates = rawData.slice(19, 38);
    const dataTable = [
        ['ประเทศ', 'สกุลเงิน', 'อัตราซื้อถัวเฉลี่ย ซื้อตั๋วเงิน', 'อัตราซื้อถัวเฉลี่ย ซื้อเงินโอน', 'อัตราขายถัวเฉลี่ย'],
        ...countries.map((country, index) => [
            country[1],
            country[0],
            rates[index][0],
            rates[index][1],
            rates[index][2]
        ])
    ];
    console.log(dataTable);

    // !!!--- Download and Read data from excel file ---!!!
    await page.getByRole('button', { name: '' }).click();
    const [download] = await Promise.all([
        page.waitForEvent('download'),
        // Perform the action that initiates the download
        page.locator('div').filter({ hasText: new RegExp(`^ข้อมูลย้อนหลังตั้งแต่ 02 มกราคม 2545 เป็นต้นไป${day}/${month}/${year}$`) }).getByRole('button').nth(4).click(),
    ]);

    const fileName = download.suggestedFilename();
    console.log(`File name is: ${fileName}`);

    // Save the downloaded file to a specific path
    const filePath = `./downloads/${fileName}`;
    await download.saveAs(filePath);
    console.log(`File path is: ${filePath}`);

    // Read the Excel file
    const workbook = new ExcelJS.Workbook();
    await workbook.xlsx.readFile(filePath);
    const worksheet = workbook.getWorksheet('ER_Sheet_1');

    // !!!--- Compare data between Excel and Exchange rate ---!!!
    // Compare DataTable with Excel data from row 4 onwards
    const startRowIndex = 3; // Row 4 (0-based index)
    for (let rowNumber = startRowIndex + 1; rowNumber <= worksheet.rowCount; rowNumber++) {
        const excelRow = worksheet.getRow(rowNumber).values.slice(1); // Get row values and remove the first empty element
        // Check if it's the last row
        const isLastRow = worksheet.rowCount;
        // Skip the comparison if the last row does not contain exactly 5 columns
        if (isLastRow == rowNumber) {
            console.log(`Skipping comparison for the last row ${rowNumber} as it does not contain exactly 5 columns.`);
            continue;
        }
        else {
            const dataTableRow = dataTable[rowNumber - startRowIndex - 1]; // Adjust index for datatable
            excelRow.forEach((cellValue, colIndex) => {
                const expectedValue = dataTableRow[colIndex];
                if (cellValue !== expectedValue) {
                    console.log(`Mismatch at row ${rowNumber}, col ${colIndex + 1}: expected ${expectedValue}, got ${cellValue}`);
                } else {
                    console.log(`Match at row ${rowNumber}, col ${colIndex + 1}: expected ${expectedValue}, got ${cellValue}`);
                }
            });
        }
    }
});

test('5.1.2 การดึงข้อมูลจาก เพื่อเปรียบเทียบความถูกต้อง (PDF)', async ({ page }) => {
    // !!!--- Go to Exchange rate and select desired date ---!!!
    const year = '2023'; // You can change this date or make it dynamic
    const month = '12'; // You can change this date or make it dynamic
    const day = '20'; // You can change this date or make it dynamic

    await page.goto('https://www.bot.or.th/th/statistics/exchange-rate.html');
    await page.getByRole('button', { name: 'ยอมรับการ ใช้งานคุกกี้ ที่จำเป็นเท่านั้น' }).click();
    await page.locator('input[type="date"]').fill(`${year}-${month}-${day}`);

    // !!!--- Extract table data from Exchange rate ---!!!
    // Wait for the table to load
    await page.waitForSelector('table');
    await page.waitForTimeout(5000);

    // Extract data from exchange rate
    const rawData = await page.evaluate(() => {
        const rows = Array.from(document.querySelectorAll('table tbody tr'));
        return rows.map(row => {
            const cells = Array.from(row.querySelectorAll('td'));
            return cells.map(cell => cell.innerText.trim());
        });
    });

    // Change extract data to datable with the same format by excel file
    const countries = rawData.slice(0, 19).map(row => row[0].split('\n\n'));
    const rates = rawData.slice(19, 38);
    const dataTable = [
        ['ประเทศ', 'สกุลเงิน', 'อัตราซื้อถัวเฉลี่ย ซื้อตั๋วเงิน', 'อัตราซื้อถัวเฉลี่ย ซื้อเงินโอน', 'อัตราขายถัวเฉลี่ย'],
        ...countries.map((country, index) => [
            country[1],
            country[0],
            rates[index][0],
            rates[index][1],
            rates[index][2]
        ])
    ];
    console.log(dataTable);

    // !!!--- Download and Read data from excel file ---!!!
    await page.getByRole('button', { name: '' }).click();
    const [download] = await Promise.all([
        page.waitForEvent('download'),
        // Perform the action that initiates the download
        page.locator('div').filter({ hasText: new RegExp(`^ข้อมูลย้อนหลังตั้งแต่ 02 มกราคม 2545 เป็นต้นไป${day}\/${month}\/${year}$`) }).getByRole('button').nth(3).click()
    ]);

    const fileName = download.suggestedFilename();
    console.log(`File name is: ${fileName}`);

    // Save the downloaded file to a specific path
    const filePath = `./downloads/${fileName}`;
    await download.saveAs(filePath);
    console.log(`File path is: ${filePath}`);

    // Read and parse the PDF file
    const pdfBuffer = fs.readFileSync(filePath);
    const pdfData = await pdfParse(pdfBuffer);

    // Extract data from the PDF content
    const pdfContent = pdfData.text;
    const pdfLines = pdfContent.split('\n').map(line => line.trim()).filter(line => line);
    
    // Improved parsing logic
    const pdfRates = pdfLines.slice(4, 23).map(line => {
        const parts = line.split(/(\d+\.\d+)/);
        const countryCurrency = parts[0].split(/(?<=\D)(?=\d)/);
        return [
            countryCurrency[0],
            countryCurrency[1],
            parts[1],
            parts[2],
            parts[3]
        ];
    });

    const pdfDataTable = [
        ['ประเทศ', 'สกุลเงิน', 'อัตราซื้อถัวเฉลี่ย ซื้อตั๋วเงิน', 'อัตราซื้อถัวเฉลี่ย ซื้อเงินโอน', 'อัตราขายถัวเฉลี่ย'],
        ...pdfRates
    ];

    console.log('Extracted Data from PDF:', pdfDataTable);

    // Compare the data
    const comparisonResults = dataTable.map((row, index) => {
        if (index === 0) return row; // Skip header row
        const pdfRow = pdfDataTable[index];
        return row.map((cell, cellIndex) => {
            if (cell === pdfRow[cellIndex]) {
                return cell;
            } else {
                return `${cell} (PDF: ${pdfRow[cellIndex]})`;
            }
        });
    });

    console.log('Comparison Results:', comparisonResults);
});

// test('1.2 การดึงข้อมูลจาก เพื่อเปรียบเทียบความถูกต้อง (Excel , Doc)', async ({ page }) => {
//     const year = '2023'; // You can change this date or make it dynamic
//     const month = '12'; // You can change this date or make it dynamic
//     const day = '25'; // You can change this date or make it dynamic

//     await page.goto('https://www.bot.or.th/th/statistics/exchange-rate.html');
//     await page.getByRole('button', { name: 'ยอมรับการ ใช้งานคุกกี้ ที่จำเป็นเท่านั้น' }).click();
//     await page.locator('input[type="date"]').fill(`${year}-${month}-${day}`);
//     await page.getByRole('button', { name: '' }).click();
//     const [download] = await Promise.all([
//         page.waitForEvent('download'),
//         // Perform the action that initiates the download
//         page.locator('div').filter({ hasText: new RegExp(`^ข้อมูลย้อนหลังตั้งแต่ 02 มกราคม 2545 เป็นต้นไป${day}/${month}/${year}$`) }).getByRole('button').nth(4).click(),
//     ]);

//     const fileName = download.suggestedFilename();
//     console.log(`File name is: ${fileName}`);

//     // Save the downloaded file to a specific path
//     const filePath = `./downloads/${fileName}`;
//     await download.saveAs(filePath);
//     console.log(`File path is: ${filePath}`);

//     // Read the Excel file
//     const workbook = new ExcelJS.Workbook();
//     await workbook.xlsx.readFile(filePath);
//     const worksheet = workbook.getWorksheet('ER_Sheet_1');

//     // Example DataTable for comparison
    const dataTable = [
        ['ประเทศ', 'สกุลเงิน', 'อัตราซื้อถัวเฉลี่ย ซื้อตั๋วเงิน', 'อัตราซื้อถัวเฉลี่ย ซื้อเงินโอน', 'อัตราขายถัวเฉลี่ย'],
        ['สหรัฐอเมริกา', 'USD', '34.3594', '34.4393', '34.7726'],
        ['สหราชอาณาจักร', 'GBP', '43.3893', '43.5078', '44.3481'],
        ['ยูโรโซน', 'EUR', '37.6293', '37.7250', '38.4384'],
        ['ญี่ปุ่น (ต่อ 100 เยน)', 'JPY', '23.9085', '24.0043', '24.6574'],
        ['ฮ่องกง', 'HKD', '4.3789', '4.3932', '4.4663'],
        ['มาเลเซีย', 'MYR', '7.3307', '7.3687', '7.5814'],
        ['สิงคโปร์', 'SGD', '25.7639', '25.8328', '26.3920'],
        ['บรูไนดารุสซาลาม', 'BND', '25.6739', '25.7639', '26.5042'],
        ['ฟิลิปปินส์', 'PHP', '0.5985', '0.6028', '0.6436'],
        ['อินโดนิเซีย (ต่อ 1000 รูเปีย)', 'IDR', '2.0640', '2.1447', '2.3467'],
        ['อินเดีย', 'INR', '0.3852', '0.3888', '0.4503'],
        ['สวิตเซอร์แลนด์', 'CHF', '40.0100', '40.0910', '40.7302'],
        ['ออสเตรเลีย', 'AUD', '23.0278', '23.0873', '23.8738'],
        ['นิวซีแลนด์', 'NZD', '21.4025', '21.4624', '22.0776'],
        ['แคนาดา', 'CAD', '25.7600', '25.8278', '26.3067'],
        ['สวีเดน', 'SEK', '3.4048', '3.4172', '3.4834'],
        ['เดนมาร์ก', 'DKK', '5.0543', '5.0685', '5.1507'],
        ['นอร์เวย์', 'NOK', '3.3350', '3.3471', '3.4324'],
        ['จีน', 'CNY', '4.7627', '4.7875', '4.9109']
    ];

//     // Compare DataTable with Excel data from row 4 onwards
//     const startRowIndex = 3; // Row 4 (0-based index)
//     for (let rowNumber = startRowIndex + 1; rowNumber <= worksheet.rowCount; rowNumber++) {
//         const excelRow = worksheet.getRow(rowNumber).values.slice(1); // Get row values and remove the first empty element
//         // Check if it's the last row
//         const isLastRow = worksheet.rowCount;
//         // Skip the comparison if the last row does not contain exactly 5 columns
//         if (isLastRow == rowNumber) {
//             console.log(`Skipping comparison for the last row ${rowNumber} as it does not contain exactly 5 columns.`);
//             continue;
//         }
//         else {
//             const dataTableRow = dataTable[rowNumber - startRowIndex - 1]; // Adjust index for datatable
//             excelRow.forEach((cellValue, colIndex) => {
//                 const expectedValue = dataTableRow[colIndex];
//                 if (cellValue !== expectedValue) {
//                     console.log(`Mismatch at row ${rowNumber}, col ${colIndex + 1}: expected ${expectedValue}, got ${cellValue}`);
//                 } else {
//                     console.log(`Match at row ${rowNumber}, col ${colIndex + 1}: expected ${expectedValue}, got ${cellValue}`);
//                 }
//             });
//         }
//     }
// });
