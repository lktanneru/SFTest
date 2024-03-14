import { LightningElement, track } from 'lwc';

export default class OfflineBanner extends LightningElement {
    @track offline = !navigator.onLine;

    constructor() {
        super();
        window.addEventListener('online', this.handleOnlineStatusChange.bind(this));
        window.addEventListener('offline', this.handleOnlineStatusChange.bind(this));
    }

    handleOnlineStatusChange() {
        this.offline = !navigator.onLine;
    }

    disconnectedCallback() {
        window.removeEventListener('online', this.handleOnlineStatusChange);
        window.removeEventListener('offline', this.handleOnlineStatusChange);
    }
}
