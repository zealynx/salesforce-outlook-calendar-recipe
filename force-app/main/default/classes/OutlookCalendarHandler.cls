public class OutlookCalendarHandler {

  @InvocableMethod(callout=true label='Save Outlook Event' description='')
  public static List<EventResponse> saveOutlookEvents(List<EventRequest> requests) {
    List<EventResponse> responses = new List<EventResponse>();
    for ( EventRequest req : requests ){      
      HttpResponse res = callout('POST', 'callout:Zealynx', headers, JSON.serialize(req);
      EventResponse er = new EventResponse();
      Map<String,Object> resMap = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
      er.isSuccess = resMap.get('isSuccess');
      er.externalId = resMap.get('externalId');
      er.externalId = resMap.get('externalId');
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
