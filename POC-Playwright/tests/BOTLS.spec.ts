import { test, expect } from '@playwright/test';

// test('Landing Page', async ({ page }) => {
//   await page.goto('https://www.botlc.or.th/');

//   // Load the page with the element
//   await page.setContent(`
//     <div class="image desktop-image fullscreen-image" style="background-image: url('https://services.botlc.or.th/BOTLCPublishFile/new10_Share_RamaX_2567_PC_size.jpg');"></div>
//   `);

//   // Type the URL into the search bar
//   await page.keyboard.type('https://services.botlc.or.th/BOTLCPublishFile/');

//   // Locate the element
//   const locator = page.locator('div.image.desktop-image.fullscreen-image');

//   // Assert the element has the expected classes
//   await expect(locator).toHaveClass(['image desktop-image fullscreen-image']);
// });

test('5.1.5 การเชื่อมต่อกับ YouTube', async ({ page }) => {
  await page.goto('https://www.botlc.or.th/');
  await page.getByLabel('allow cookies').click();
  await page.getByRole('link', { name: 'เข้าสู่เว็บไซต์' }).click();

  // // Load the page with the element
  // await page.setContent(`
  //   <div id="movie_player">
  //     <div>
  //       <button class="ytp-large-play-button ytp-button ytp-large-play-button-red-bg" aria-label="Play" title="Play">
  //       </button>
  //     </div>
  //   </div>
  // `);

  // // Locate the button element using CSS selector
  // const button = page.locator('button.ytp-large-play-button');

  const iframe = page.frameLocator('iframe[src*="youtube.com"]');
  // Locate the button within the iframe using a combination of attributes
  const button = iframe.locator('button[aria-label="Play"][title="Play"].ytp-large-play-button.ytp-button.ytp-large-play-button-red-bg');
  await button.waitFor({ state: 'visible' });

  // Check if the button has the correct aria-label
  await expect(button).toHaveAttribute('aria-label', 'Play');
  // Check if the button has the correct title
  await expect(button).toHaveAttribute('title', 'Play');
  // Check if the button has the correct class
  await expect(button).toHaveClass('ytp-large-play-button ytp-button ytp-large-play-button-red-bg');

});

test('5.1.6 การเชื่อมต่อกับ Facebook', async ({ page, context }) => {
  await page.goto('https://www.botlc.or.th/');
  await page.getByLabel('allow cookies').click();
  await page.getByRole('link', { name: 'เข้าสู่เว็บไซต์' }).click();

  // !!!--- Verify facebook icon element has got link https://www.facebook.com/BOTLearningCenter ---!!!
  const facebookIcon = await page.locator('a:has(img[src="https://www.botlc.or.th/public/img/simple-icons/facebook.svg"])');
  await expect(facebookIcon).toHaveAttribute('href', 'https://www.facebook.com/BOTLearningCenter/');
("
  ")("
    ")")
  // !!!--- Verify after clicking facebook icon should be https://www.facebook.com/BOTLearningCenter ---!!!
  await Promise.all([
    facebookIcon.click()
  ]);

  // Assert that the new page URL is correct
  await expect(page).toHaveURL('https://www.facebook.com/BOTLearningCenter/');

  // // !!!--- Verify after redirect to BOTLearningCenter should have text correctly ---!!!
  // await page.getByText('See more on Facebook').waitFor({ state: 'visible' });
  // Wait for the email input to be visible and interactable
  const emailInput = page.getByRole('textbox', { name: 'Email address or phone number' });
  await emailInput.waitFor({ state: 'visible' });
  await emailInput.fill('atiwit2011@hotmail.com');
  // Wait for the email input to be visible and interactable using dynamic delay
  // await waitForCondition(async () => {
  //   return await page.getByRole('textbox', { name: 'Email address or phone number' }).isVisible();
  // });
  const passwordInput = page.locator('#login_popup_cta_form').getByRole('textbox', { name: 'Password' });
  await passwordInput.waitFor({ state: 'visible' });
  await passwordInput.click();
  await passwordInput.fill('dream6010742333');

  const loginButton = page.getByLabel('Accessible login button');
  await loginButton.waitFor({ state: 'visible' });
  await loginButton.click();

  // Verify the element contains the text "ศูนย์การเรียนรู้แบงก์ชาติ - BOTLC"
  await expect(page.locator('h1')).toHaveText('ศูนย์การเรียนรู้แบงก์ชาติ - BOTLC');
});

// async function waitForCondition(conditionFn, timeout = 10000, interval = 100) {
//   const startTime = Date.now();
//   while (Date.now() - startTime < timeout) {
//     if (await conditionFn()) {
//       return;
//     }
//     await new Promise(resolve => setTimeout(resolve, interval));
//   }
//   throw new Error('Timeout waiting for condition');
// }

