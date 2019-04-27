import axeCheck from 'axe-testcafe';
import {Selector} from 'testcafe';
import LoginPage from './pages/login-page';

fixture(`The landing page`)
    .page(`http://localhost:3300`);

test('if not logged in, should have the "Register" button', async t => {
    const logo = Selector('.usa-logo__text');
    const registerButton = Selector('a#register-button-link');

    await axeCheck(t);

    await t
        .expect(logo.innerText).eql('Diffusion Marketplace')
        .expect(registerButton.exists).ok();

});

test('if logged in, should not have the "Register', async t => {
    const loginPage = new LoginPage();
    const loginButton = Selector('a#header-login-link');
    const registerButton = Selector('a#register-button-link');
    const signedInAlert = Selector('.usa-alert--info');

    await axeCheck(t);

    await t.expect(loginButton.exists).ok()
        .expect(registerButton.exists).ok()
        .click(loginButton);

    await axeCheck(t);

    await t
        .typeText(loginPage.emailInput, 'demo@va.gov')
        .typeText(loginPage.passwordInput, 'Demo#123')
        .click(loginPage.submitButton);

    await axeCheck(t);

    await t
        .expect(signedInAlert.exists).ok()
        .expect(registerButton.exists).notOk();

});
