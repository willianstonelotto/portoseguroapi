unit u_PortoSeguroAPI;

interface

uses
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.JSON,
  IdHTTP,
  IdMultipartFormData,
  IdCookieManager,
  IdURI;


type
  TPortoSeguroAPI = class

  private
    IdHTTP : TIdHTTP;

  public
    constructor Create;
    destructor Destroy; override;

    function LoginPorto(aUsername, aPassword : string) : string;
    function UploadPorto(Cookie, AFilename : string) : string;
  end;



implementation

{ TPortoSeguroAPI }

{$REGION 'Constructor / destructor methods'}
constructor TPortoSeguroAPI.Create;
begin
   IdHTTP                   := TIdHTTP.Create(nil);
   IdHTTP.AllowCookies      := True ;
   IdHTTP.CookieManager     := TIdCookieManager.Create;
   IdHTTP.Request.UserAgent := 'Mozilla/3.0 (compatible; Indy Library)';
end;

destructor TPortoSeguroAPI.Destroy;
begin
  IdHTTP.Free;
  inherited;
end;
{$ENDREGION}

{$REGION 'methods'}
function TPortoSeguroAPI.LoginPorto(aUsername, aPassword: string): string;
var
  FPostCookieLogin : TIdMultiPartFormDataStream;
  FRespCookieLogin : TStringStream;
  FCookieName, FCookieText : string;
begin
   try
     FRespCookieLogin := TStringStream.Create('');

     FPostCookieLogin := TIdMultiPartFormDataStream.Create;
     FPostCookieLogin.AddFormField( 'mod' , 'login' );
     FPostCookieLogin.AddFormField( 'comp' , '5' );
     FPostCookieLogin.AddFormField( 'user' , aUsername);
     FPostCookieLogin.AddFormField( 'pass' , aPassword);

     IdHTTP.Request.ContentType := ' CONTENT TYPE PORTO ';

     IdHTTP.Post('INSERIR A URL DA PORTO',
                 FPostCookieLogin, FRespCookieLogin);

     FCookieName := IdHTTP.CookieManager.CookieCollection.Cookies[0].CookieName;
     FCookieText := IdHTTP.CookieManager.CookieCollection.Cookies[0].CookieText;

     FRespCookieLogin.DataString;

     Result := Copy(FCookieText, Pos('portal[ses]', FCookieText), Pos( ';', FCookieText)- 1 );
   finally
     FRespCookieLogin.Free;
     FPostCookieLogin.Free;
   end;
end;

function TPortoSeguroAPI.UploadPorto(Cookie, AFilename: string): string;
var
 FPostFileStream : TIdMultiPartFormDataStream;
 FRespFileStream : TStringStream;
 URI : TIdURI;
begin
   Result := '';

   try
      FPostFileStream := TIdMultiPartFormDataStream.Create;
      FPostFileStream.AddFormField('comp', '5' );
      FPostFileStream.AddFormField('mod' , 'Upload' );
      FPostFileStream.AddFormField('path', 'eguarda/php/' );

      FPostFileStream.AddFile('file', AFilename);

      FRespFileStream := TStringStream.Create('');

      URI := TIdURI.Create(' INSERIR A URI DA PORTO ');

      IdHTTP.Request.ContentType := '';
      IdHTTP.CookieManager.AddServerCookie(Cookie, URI);

      IdHTTP.Post(' INSERIR A URL DE AVERBAÇÃO DA PORTO ',
                   FPostFileStream, FRespFileStream);

      Result := FRespFileStream.DataString;
   finally
     FPostFileStream.Free;
     FRespFileStream.Free;
   end;
end;
{$ENDREGION}

end.
