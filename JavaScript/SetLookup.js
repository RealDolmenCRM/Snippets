/*
 * TAGS: CRM2011, CRM2013, CRM2015, JScript
 * */

function SetLookup(fieldname, recordId, recordType, recordName) {
	var lookupAtt = Xrm.Page.getAttribute(fieldname);
	if (lookupAtt != null) {
		var lookupValue = new Array();
		lookupValue[O] = new Object();
		lookupValue[0].id  recordId;
		lookupValue[0].entityType  recordType;
		lookupValue[0].name  recordName;
		lookupAtt.setValue(lookupValue);
	}
}
