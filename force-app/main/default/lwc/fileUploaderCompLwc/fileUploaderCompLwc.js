import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import uploadFile from '@salesforce/apex/FileUploaderCompHandler.uploadFile'
import { RefreshEvent } from 'lightning/refresh';

const MAX_FILE_SIZE = 2097152;
export default class FileUploaderCompLwc extends LightningElement {
    @api recordId;
    @api docType;
    @api fileName = ''
    fileData = []
    @api extendedName = ''
    @api queName = ''
    isLoading = false
    @track filename2 = ''
    @track showDeleteIcon = false
    @api label =""
    @api comingFrom =''
    @api trainingId =''
    @api evidenceType =''

    connectedCallback(){
        console.log('inside child init')
        
    }


    openfileUpload(event) {
        if(this.comingFrom === "Training" && (this.trainingId === '' || this.trainingId === undefined || this.trainingId === null)){
            this.ShowToast('Error', 'Please save the training details before uploading the file', 'error', 'dismissable');
            return
        }
        this.isLoading = true
        const file = event.target.files[0]
        var reader = new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            var filetype = file.type
            var nameOfTheFile = file.name
            var filesize = file.size
            
            
            if (filetype != 'image/jpeg' && filetype != 'image/jpg' && filetype != 'image/png' && filetype != 'application/pdf' && filetype != 'message/rfc822' && filetype != 'message/eml' && filetype != 'text/csv' && filetype != 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' && filetype != 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' && filetype != 'application/vnd.ms-excel' && filetype != 'application/vnd.ms-powerpoint' && filetype != 'application/vnd.openxmlformats-officedocument.presentationml.presentation' && filetype != 'application/msword' && filetype != 'msg') {
                this.isLoading = false
                
                this.ShowToast('Error', 'Unsupported file type.  Please upload the file in a different format.', 'error');
                return;
            }
            console.log("nameOfTheFile: ", nameOfTheFile);
            if (nameOfTheFile.includes(';')) {
                this.isLoading = false
                this.ShowToast('Error', 'File name should not contain semicolon (;) character.', 'error');
                return;
            }

            if (Math.floor(filesize / 1000) > 3000) {
                this.isLoading = false
                this.ShowToast('Error', 'Please upload file with size less than 3000 KB(3 MB). Current uploaded file is of ' + (Math.floor(filesize / 1000)) + ' KB', 'Error');
                return;
            }
            if(this.comingFrom !== "Training"){
                this.fileData = {
                    'filename': this.fileName != '' && this.fileName != undefined ? this.extendedName != '' && this.extendedName != undefined ? file.name + ';' + this.extendedName + ';' + this.fileName : file.name + ';' + this.fileName : file.name,
                    'base64': base64,
                    'recordId': this.recordId,
                    'DocType': file.name.split('.').pop().toLowerCase(),
                    'filename2': file.name
                }
            }else if(this.comingFrom === "Training"){
                this.fileData = {
                    'filename': this.fileName != '' && this.fileName != undefined ? 
                                    this.extendedName != '' && this.extendedName != undefined ? file.name + ';'+ this.queName +';'+ this.evidenceType+'/'+ this.extendedName
                                    : file.name + ';' + this.fileName : file.name,
                    'base64': base64,
                    'recordId': this.recordId,
                    'DocType': file.name.split('.').pop().toLowerCase(),
                    'filename2': file.name
                }
            }
            console.log('filedata  is s     '+this.fileData)
            
            this.isLoading = false
            this.showDeleteIcon = true
            this.handleClick(event)
        }
        reader.readAsDataURL(file)
       
    }



    deleteSelectedRecords(event) {
        if (event.target.dataset.delFilename == 'HiveFile') {


            this.filename2 = ''
            this.fileData = {}
            this.showDeleteIcon = false
        }
    }

    @api
    handleClick(event) {
        this.isLoading = true
        event.preventDefault();
        if (this.fileData) {
            console.log('fileData : ', this.fileData);
            const { base64, filename, recordId, DocType, filename2 } = this.fileData
            uploadFile({ base64, filename, recordId, DocType, filename2 }).then(result => {
                this.dispatchEvent(new RefreshEvent())
                const custEvent = new CustomEvent(
                    'callpasstoparent', {
                    detail: {
                        filenameValue: filename2,
                        fileTypeValue: DocType
                    }
                });

                this.dispatchEvent(custEvent);
                this.fileData = null
                this.isLoading = false
                console.log('OUTPUTresult : ', result);
                //let title = `${filename} uploaded successfully!!`
                this.ShowToast(`${filename2} uploaded successfully.  View  all uploaded files in the Submit for Approval tab.`, '', 'Success');
                //this.dispatchEvent(new CustomEvent("upload", {}));

            }).catch(e => {
                console.log('OUTPUT e : ', e);
                this.isLoading = false
                this.ShowToast('Error', e.name + ': ' + e.message, 'error', 'dismissable');
                //this.dispatchEvent(new CustomEvent("upload", {}));
            });
        }
        else {
            console.log('No File Uploaded : ',);
            //this.dispatchEvent(new CustomEvent("upload", {}));
        }
    }

    ShowToast(title, message, variant, mode) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }

    removeReceiptImage(event) {
        var index = event.currentTarget.dataset.id;
        this.filesData.splice(index, 1);
    }
    get target(){
        return this.comingFrom === "Training" ? true: false }

}