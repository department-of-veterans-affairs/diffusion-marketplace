import { Selector } from 'testcafe';

export default class LoginPage {
    constructor () {
        this.emailInput     = Selector('#user_email');
        this.passwordInput  = Selector('#user_password');
        this.submitButton = Selector('input[type="submit"]');
    }
}