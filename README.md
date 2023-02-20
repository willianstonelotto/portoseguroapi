# portoseguroapi
unit em Delphi para consumir a api de averbação da porto seguro

Exemplo de utilização da unit em Delphi

     Resp := '';

     t := TThread.CreateAnonymousThread(procedure
     var
       FMensagemRetorno : string;
     begin
        Porto := TPortoSeguroAPI.Create;

        FCookie := Porto.LoginPorto(USUARIO API DA PORTO, SENHA DA API DA PORTO);

        CTe.First;
        while NOT CTe.Eof do
        begin
           Resp := Porto.UploadPorto(FCookie, CTeCAMINHOCTe.AsString );

           if Resp <> '' then
           begin
              json := TJSONObject.ParseJSONValue(Resp) as TJSONObject;

               TThread.Synchronize(TThread.CurrentThread, procedure
               begin
                  if ( Pos ( '"P":1' , resp) > 0 ) then
                    FMensagemRetorno := 'Processado (sucesso)'
                  else
                  if ( Pos ( '"D":1' , Resp) > 0 ) then
                    FMensagemRetorno := 'Duplicidade de xml'
                  else
                  if ( Pos ( '"R":1' , Resp) > 0 ) then
                    FMensagemRetorno := 'xml com erro'
                  else
                  if ( Pos ( '"N":1' , Resp) > 0 ) then
                    FMensagemRetorno := 'Negado (Não é xml ou zip)'
                  else
                    FMensagemRetorno := 'Erro inesperado: Entre em contato com a operadora de seguro.' ;

			
			          // AQUI VOCE PODE GRAVAR A RESPOSTA DA AVERBAÇÃO	
               end);

           end;

          CTe.Next;
        end;

     end);

     t.OnTerminate     := onTerminatePorto;
     t.FreeOnTerminate := True;
     t.Start;
