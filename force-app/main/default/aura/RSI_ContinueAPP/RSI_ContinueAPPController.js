({
	 doInit: function(cmp, evt, helper) {
        var myPageRef = cmp.get("v.pageReference");
        var recordId = myPageRef.state.c__recordId;
        var accountId = myPageRef.state.c__accountId;
        var readOnlyStatus = myPageRef.state.c__readOnlyStatus;
        cmp.set("v.recordId", recordId);
        cmp.set("v.accountId", accountId);
        cmp.set("v.readStatusOnly", readOnlyStatus);
    }
})