public class OutlookCalendarHandler {

  static Map<Id,sObject> queryRecords(Set<Id> ids){
    //  MODIFY THIS TO MEET YOUR PURPOSES
    String queryString = 'SELECT ';
    queryString += ' FROM ';
    queryString += ' WHERE Id IN: ids';
    List<sObject> records = database.query(queryString);
    return new Map<Id,sObject>(records);
  }
	
	
  @InvocableMethod(callout=true label='Save Outlook Event' description='')
  public static List<EventResponse> saveOutlookEvents(List<EventRequest> requests) {
    List<EventResponse> responses = new List<EventResponse>();
    Map<Id,sObject> idRecordMap = new Map<Id,sObject>();
    for ( EventRequest req : requests ){      
      ids.add(req.recordId);
    }
    Map<Id,sObject> recordMap = queryRecords(ids);
    for ( EventRequest req : requests ){
      req.record = idRecordMap.get(req.recordId);    
      HttpResponse res = callout('POST', 'callout:Zealynx', headers, JSON.serialize(req);
      EventResponse er = new EventResponse();
      Map<String,Object> resMap = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
      if ( resMap.containsKey('isSuccess') ){
        er.isSuccess = resMap.get('isSuccess');
      }
      if ( resMap.containsKey('errorMessage') ){
        er.errorMessage = resMap.get('errorMessage');
      }
      if ( resMap.containsKey('externalId') ){
        er.externalId = resMap.get('externalId');
      }
      responses.add(er);
    }
    return responses;
  }

  public class EventRequest {
    @InvocableVariable(label='Source Object' description='' required=true)
    public String zealynx_sourceObject;

    @InvocableVariable(label='Source Operation' description='' required=true)
    public String zealynx_sourceOperation;

    @InvocableVariable(label='RecordId' description='' required=true)
    public Id recordId;
	  
    sObject record;
  }


  public class EventResponse {
    @InvocableVariable(label='isSuccess' description='')
    public Boolean isSuccess;

    @InvocableVariable(label='Reference' description='Unique Reference for this record')
    public String externalId;

    @InvocableVariable(label='Error Message' description='')
    public String errorMessage;
  }

  /**
   * @name callout
   */
  public static HttpResponse callout(String method, String endpoint, List<List<String>> headers, String body){
		HttpRequest req = new HttpRequest();
		req.setMethod(method);
    req.setEndpoint(endpoint);
    if ( headers == null ){
      headers = new List<List<String>>();
      headers.add(new List<String>{'Content-Type','application/json'});
      headers.add(new List<String>{'Accept','application/json'});
    }
    for ( List<String> header : headers ){
      req.setHeader(header[0],header[1]);
    }
    if ( String.isNotBlank(body) ){
      req.setBody(body);
    }
    HttpResponse res = new Http().send(req);
    system.debug( res.toString() );
    system.debug( res.getBody() );
		return res;        
  }
