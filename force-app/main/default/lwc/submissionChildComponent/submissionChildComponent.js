import { LightningElement, api, track } from 'lwc';
import chatterPostFeed from '@salesforce/apex/chatterPost.chatterPostFeed';
import updateURLToSubField from '@salesforce/apex/chatterPost.updateURLToSubField';
import sendEmailNotifications from '@salesforce/apex/chatterPost.sendEmailNotification'
import LightningAlert from "lightning/alert";
export default class SubmissionChildComponent extends LightningElement {
@api getEntityName;
@api getReportYear;
@api getTab;
@api getOnlineSubId;
@api getCoreStdEntity;
@track currentURL;
commentValue;
@api mentionUser = [];
@track userIds;


handleChange(event){
    this.commentValue = event.target.value;
}

async handleAlert() {
    await LightningAlert.open({
        message: "Refresh the feed below by clicking on the circular arrow to see your latest post",
        theme: "success",
        label: "Posted to chatter"
    });
}

async displayAlert() {
    await LightningAlert.open({
        message: "Please enter comment value",
        theme: "warning",
        label: "Comment value is missing"
    });
}

    handle_Update(event){
        if(this.commentValue != null && this.commentValue != ''){
            console.log('Calling chatterPostFeed method' + this.getTab + this.mentionUser + this.commentValue +this.getCoreStdEntity);
            chatterPostFeed({getEntityName : this.getEntityName,
                            getReportYear : this.getReportYear,
                            getTab : this.getTab,
                            getOnlineSubId : this.getOnlineSubId,
                            commentValue : this.commentValue,
                            getCoreStdEntity : this.getCoreStdEntity,
                            mentionUser : this.mentionUser})
            .then((result) => {
                console.log('result is ->', result);
                this.userIds = result;
                console.log('UserIds'+this.userIds)
               
                this.handleAlert();
                this.clearCommentValue();
                this.currentURL = window.location.href;
                this.setURLToSubField(this.currentURL, this.getOnlineSubId);
                this.sendEmailNotification(this.getOnlineSubId,this.userIds);
            })
            .catch((error) => {
                this.error = error;
            });

    }
    else{
        this.displayAlert();
    }
}

    setURLToSubField(onSubField, onlineSubId){
    updateURLToSubField({onSubField : this.currentURL, onlineSubId : this.getOnlineSubId})
    }


sendEmailNotification(OnlineSubId,TaggedUsers){
    sendEmailNotifications({OnlineSubId : this.getOnlineSubId, TaggedUsers : this.userIds})
    .then(data=>{      
        if(data){
            console.log('Executed successfully');
        }
    })
    .catch(error =>{
        this.error = error;
    });
}

    handleSelection(event){
        console.log("the selected record id is"+JSON.stringify(event.detail));
        this.mentionUser.push(JSON.stringify(event.detail).split(':')[1].replace(/["" {}]/g,''));
        console.log(this.mentionUser)
    }

    clearCommentValue(){

        this.template.querySelectorAll('lightning-textarea').forEach(element => {
            console.log('cleare method called')
            if(element.type === 'checkbox' || element.type === 'checkbox-button'){
              element.checked = false;
            }else{
              element.value = null;
              this.template.querySelector('c-custom-lookup')?.handleRemove();
              this.mentionUser = [];
              this.commentValue = '';
              console.log('Values cleared in array mentionUser', this.mentionUser, this.commentValue);
            }      
          });
        }

    refreshComponent(event){
        eval("$A.get('e.force:refreshView').fire();");
    }

}