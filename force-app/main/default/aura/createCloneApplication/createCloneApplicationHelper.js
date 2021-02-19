({
    handleSave : function(component, event, helper) {
        component.set("v.showSpinner", true);
        
        let isValidData = this.validateFields(component, event, helper);        
        
        if(isValidData){
            (this).doCallout(component, 'c.cloneOpportunity', {
                "applicationId": component.get('v.recordId'),
                "appName": component.get('v.applicationName')
            }, function (response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    var returnResult = response.getReturnValue();
                    
                    if (this.isNotEmpty(component, returnResult)) {
                        if (returnResult) {
                            this.showToast(component, 'Success', 'Record has been cloned successfully.', 'success');
                            console.log('returnResult===' + returnResult);
                            var navEvt = $A.get("e.force:navigateToSObject");
                            navEvt.setParams({
                                "recordId": returnResult,
                                "slideDevName": "related"
                            });
                            navEvt.fire();
                            $A.get("e.force:closeQuickAction").fire();                          
                        }
                    }
                }
                
                component.set("v.showSpinner", false);
            });
        }else{
            component.set("v.showSpinner", false);
        }
    },
    
    isNotEmpty: function (component, value) {
        if (value !== null && value !== '' && value !== undefined)
            return true;
        return false;
    },
    
    // TO MAKE CALLOUT TO SERVER METHOD.
    doCallout: function (component, methodName, params, callBackFunction) {
        var action = component.get(methodName);
        action.setParams(params);
        action.setCallback(this, callBackFunction);
        $A.enqueueAction(action);
    },
    
    showToast: function (component, title, msg, type) {
        var duration = (type === 'error' || type === 'Error') ? '10000' : '5000';
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "title": title,
            "message": msg,
            "type": type,
            "duration": duration
        });
        
        toastEvent.fire();
    },
    
    validateFields : function(component, event, helper) {
        var application = component.find("appNameId");
        var applicationValue = application.get("v.value");
        var isValidName = false;
        
        if (applicationValue === null || applicationValue === '' || applicationValue === undefined ) {
            $A.util.addClass(application, 'slds-has-error');
            application.showHelpMessageIfInvalid();
        } else {
            application.setCustomValidity("");
            application.reportValidity();
            $A.util.removeClass(application, 'slds-has-error');
            isValidName = true;
        }
        
        return isValidName;
    }
})