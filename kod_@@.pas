
    { Private declarations }
    function ZamienStrToFloat(asWartosc: String): Extended;
    function ZamienStrToDateTime(asWartosc: String): TDateTime;
    procedure _ErrorToFILE(sErr: String; bShow: boolean = true);
    // bd do pliku
    procedure UsunPozycje;

    procedure EnableButtons(bEnabled: boolean);
    procedure GetCLICKEDProduct;
    procedure ClearProduct;

    // Otwarcie tabeli slownikowej
    procedure OpenTable_Dictionary;

    // Otwarcie tabeli zamówie
    procedure OpenTable_Order;
    // Otwarcie tabeli zamówie - podgld
    procedure Open_TempOrder;

    procedure Prepare;
    procedure User_Logout;

    procedure SendOrder(sParams: String); // Wylij zamowienie na serwer
    procedure ClearOrder; // wyczy wszystkie pola zamówienia po wysaniu

    procedure GetNewDictionary; // podbanie nowej tbl sownikowej wg daty
    procedure GetNewPictures;
    procedure GetNewREGON;

    // function CheckDictLAST_DATE:String; // sprawdzenie ostatniej aktualizacji wg pola z tbl sownikowej
    function CzyWczytane_SERWER: boolean;
    procedure SkasujPobrane_SERWER(iNr: Integer);
    procedure ShowNotify(sNotka: String);
    procedure ServerOrderRead;

    { ===========================================================================
      status :
      TRUE - poszo
      FALSE - nie poszo

      zamówienie wrzucane jest w caoci ,bez wzgldu na ilo pozycji - plik PHP
      =========================================================================== }
    function JSONPHPAnswer(sJString: String): boolean;
    { ==========================================================================

      GPS : Arcus Tangens 2

      =========================================================================== }
    procedure PrepareImageURL;

    function GetMAXid_ZAM: Integer; // nr zamowienia

    function USER_Login(sJString: String): boolean;

    procedure FDConnect(bConn: boolean);
    // procedure FTPConnect;
    // procedure GetFTPFile(sFName : String);

    function GetURLFile(sUrlName, sSubDirectory, sLocalName: String): boolean;
    function GetURLExtension(sURL: String): String;

    procedure QuestionYN(Sender: TObject);
    // procedure InsertOrder2List(sF, sW: String;iNr:Shortint);
    function GPS_CHECK: boolean;

    function PrepareOrderToSend(sZnacznik, cAnuluj: Char): String;

    procedure ClearOrderChoice(bONOFF: boolean);
    procedure ExecuteQUERY(sCO: String; sTabela: String);
    procedure TThreadProc;
    function strGetPicLnkByID(sTyp: String; iNr: Integer): String;
    procedure MakePictureThumbs;

  public

    { Public declarations }
    procedure SetStyle(sParam: String);
    function ReadApplicationStyle: String;

  end;

Const
  _UserINIf = 'userini';
  _sTblSlownikowa = 'developer.db';
  {

    GLOBALNE ZMIENE DLA SERWERA FTP I SKRYPTU LOGOWANIA

  }

{$DEFINE TESTOWAzzz}
{$IFDEF TESTOWA}
  _sGLOBAL_IP_HOST = '192.168.0.4'; // WIFI
  // _sGLOBAL_IP_HOST = '192.168.0.10'; // LAN
  _sGLOBAL_HTTP_PORT = ':80';
  _sGLOBAL_LOGIN_USER = 'l@j.pl';
  _sGLOBAL_LOGIN_PASS = 'ljljlj';

{$ELSE}
  _sGLOBAL_IP_HOST = '87.156.0.133';
  _sGLOBAL_HTTP_PORT = ':8080';
  // _sGLOBAL_LOGIN_USER = 'l@j.pl';
  // _sGLOBAL_LOGIN_PASS = 'ljljlj';
  _sGLOBAL_LOGIN_USER = '';
  _sGLOBAL_LOGIN_PASS = '';

{$ENDIF}

  // _sGLOBAL_USER_LOGIN =_sGLOBAL_IP_HOST+_sGLOBAL_HTTP_PORT+'/user/userlogin';
  // _sGLOBAL_GPS_POS =_sGLOBAL_IP_HOST+_sGLOBAL_HTTP_PORT+'/user/gpspos';
  // _sGLOBAL_DEL_ORDER =_sGLOBAL_IP_HOST+_sGLOBAL_HTTP_PORT+'/user/delorder';
  // _sGLOBAL_SHOW_ORDERS =_sGLOBAL_IP_HOST+_sGLOBAL_HTTP_PORT+'/user/showmyorders';
  // _sGLOBAL_GET_ORDER =_sGLOBAL_IP_HOST+_sGLOBAL_HTTP_PORT+'/user/getorder';
  // _sGLOBAL_INSERT_ORDER =_sGLOBAL_IP_HOST+_sGLOBAL_HTTP_PORT+'/user/insertOrder';
  //
  // _sGLOBA_GET_REGON =_sGLOBAL_IP_HOST+_sGLOBAL_HTTP_PORT+'/user/getregon';
  // _sGLOBAL_GET_PICS =_sGLOBAL_IP_HOST+_sGLOBAL_HTTP_PORT+'/user/getpic';
  // _sGLOBAL_GET_DICT =_sGLOBAL_IP_HOST+_sGLOBAL_HTTP_PORT+'/user/getdictionary';

  // logowanie uytkownika
  _sGLOBAL_USER_SCRIPT = '/developer/d2php2d/user_login.php';

  // pobranie nowych tabel
  _sGLOBAL_GET_DICT = '/developer/d2php2d/v2get_dictionary.php';
  _sGLOBAL_GET_PICS = '/developer/d2php2d/get_table_pic.php';
  _sGLOBAL_GET_REGON = '/developer/d2php2d/get_regon.php';

  // wysanie zamówie na serwer
  _sGLOBAL_ORDER_INS = '/developer/d2php2d/insert.order.php';

  // sprawdzenie koordynatów
  _sGLOBAL_GPS_CHECK = '/developer/d2php2d/gps_coords.php';

Resourcestring
  {
    komunikaty INFO
  }
  _strNewDBLoaded = 'Najnowsza baza zostaa poprawnie pobrana';

  _strSendOrder = 'Czy napewno wysa zamówienie na serwer ?' + sLineBreak + 'Po zaakceptowaniu pozycje dotychczasowego zamówienia' + sLineBreak + 'zostan wyczyszczone.';

  _strDelOrderPos = 'Czy usun wybran pozycj z zamówienia ?';

  _strSOrderOK = 'Zamówienie zostao poprawnie wysane na serwer';

  _strGOrderOK = 'Zamówienie zostao poprawnie wczytane';

  {
    komunikaty  ERROR
  }

  _strERR_EmptyOrder = 'Zamówienie nie posiada pozycji.';

  _strERR_SOrder = 'Zamówienie nie zostao wysane.' + sLineBreak + 'Spróbuj ponownie póniej ( brak zasigu sieci ? ).';

  _strERR_zamID = 'Bd pobrania numeru zamówienia !' + sLineBreak + 'Dalsza praca nie jest moliwa.' + sLineBreak + 'Zgo problem administratorowi !';

  _strERR_Login = 'Brak moliwoci zalogowania uytkownika.' + sLineBreak + 'Bd zosta zapisany w pliku';

  _strERR_NODB = 'Brak pliku bazy danych';

  _strERR_NOGPS = 'Znajdujesz si poza placem budowy.' + sLineBreak + 'Wysyanie i odbieranie zamówie nie bdzie moliwe.';

var

  // dmBaza: TdmBaza;
  devFrm: TdevFrm;

  _SELECTED_ORDER: String;
  _ORDER_LIST: array of String;

  __iGLOBAL_USER_ID: Integer = -1;
  __sGLOBAL_CONSTR_NAME: String;
  __iGLOBAL_ID_ZAM: Integer;
  __bCAN_SEND_ORDER: boolean;
  // true : mona / false : nie mona wysa zamówienia

  _LAT, _LNG: Extended; // koordynaty GPS

  asGlobalFileNameImage: String;
  iGlobalTowarId: Integer;

implementation

{$R *.fmx}
{$IFDEF ANDROID}

Uses
  System.Json,
  System.zip,
  uGPS,
  Androidapi.Helpers,
  Androidapi.JNI.App,
  ModalFM,
  StrUtils,
  Settings,
  FMX.Styles,


  // pdf +

  System.IOUtils,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Net;

{$ENDIF}
{
}

{

  KLIK LUB EXTCLICK

}

procedure TdevFrm.GetCLICKEDProduct;

var
  sSQL: String;

begin

  sSQL := 'SELECT ' + 'towar.id as id_towar,towar.indeks, towar.ean, towar.nazwa,' + 'towar.dostawca,towar.dostawcaid,towar.producent,towar.producentid,' + 'towar.data_mod,towar.jm,towar.cena,' +

    'regondostawca.id as id_regondostawca, ' + 'regondostawca.identyfikator as dostawcaidentyfikator,' + 'regondostawca.nazwa as dostawcanazwa,' + 'regondostawca.minimum,' +

    'regonproducent.id as id_regonproducent,' + 'regonproducent.identyfikator as producentidentyfikator,' + 'regonproducent.nazwa as producentnazwa' +

    ' FROM towar' + ' LEFT OUTER JOIN regon regondostawca ON towar.dostawcaid = regondostawca.id' + ' LEFT OUTER JOIN regon regonproducent ON towar.producentid = regonproducent.id ' +
    'WHERE towar.id=:idtowar;';

  qry_towar.Close;
  qry_towar.SQL.Clear;
  qry_towar.SQL.Add(sSQL);
  qry_towar.Params.ParamByName('idtowar').AsInteger := iGlobalTowarId;

  try
    qry_towar.Open;

  except
    on e: Exception do
      _ErrorToFILE(e.Message);
  end;

  edJM.Text := qry_towarjm.AsString;
  edNazwa.Text := qry_towarnazwa.AsString;
  spMinVal.Value := 1;
  edCenaTowaru.Text := CurrToStrF(qry_towarcena.AsCurrency, ffCurrency, 2);

end;

procedure TdevFrm.ClearProduct;
begin
  edJM.Text := '';
  edNazwa.Text := '';
  spMinVal.Value := 1;
  edCenaTowaru.Text := '0,00';
  Image2.Bitmap.Assign(nil);
end;

procedure TdevFrm.ListView1DblClick(Sender: TObject);
begin
  // ExecuteAction(NextTabAction1);
end;

// procedure TdevFrm.ListView1ItemClickEx(const Sender: TObject;
// ItemIndex: Integer; const LocalClickPos: TPointF;
// const ItemObject: TListItemDrawable);
//
// begin
//
// if LocalClickPos.X >= TListView(Sender).Width - 60 then
// ExecuteAction(NextTabAction1);
//
// end;
//
// procedure TdevFrm.ListView1Tap(Sender: TObject; const Point: TPointF);
// begin
// GetCLICKEDProduct;
// ExecuteAction(NextTabAction1);
// PrepareImageURL;
// end;

// procedure TdevFrm.ListView2DblClick(Sender: TObject);
// var
// X, I: Integer;
//
// begin

// for I := 0 to ListView2.Items.Count-1 do
// x:=ListView2.Selected.Index;
// Showmessage(ListView2.Items[x].Text);
//
// end;
{
  procedure TdevFrm.ListView4ButtonClick(const Sender: TObject;
  const AItem: TListItem; const AObject: TListItemSimpleControl);

  begin
  if AObject.name = 'TextButton4' then
  begin
  showmessage('Wczytanie ' + AItem.Index.ToString);
  edTowarID.Text := AItem.Index.ToString;
  end;

  end;
}

procedure TdevFrm.ListView4ItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  // edTowarID.Text := ListView4.Selected.Index.ToString;
  // ExecuteAction(NextTabAction1);
end;

procedure TdevFrm.ListView4ItemClickEx(const Sender: TObject; ItemIndex: Integer; const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
begin
  iGlobalTowarId := ListView4.Items[ItemIndex].Tag;

  // ItemIndex + 1;              //   !!!!!!!!!!!!
  // edTowarID.Text := IntToStr(ItemIndex);
  // TabControl1.ActiveTab := tabSzczegoly;
  ExecuteAction(chTabSzczegoly);
  // ExecuteAction(NextTabAction1);
end;

procedure TdevFrm.ListView4Tap(Sender: TObject; const Point: TPointF);
begin
  // edTowarID.Text := ListView4.Selected.Index.ToString;
  // ExecuteAction(NextTabAction1);
end;

procedure TdevFrm.LocationSensor1LocationChanged(Sender: TObject; const OldLocation, NewLocation: TLocationCoord2D);

var
  LDecSeparator: String;

begin

  LDecSeparator := FormatSettings.DecimalSeparator;
  FormatSettings.DecimalSeparator := '.';

  _LAT := NewLocation.Latitude;
  _LNG := NewLocation.Longitude;
  // Format('%2.6f', [NewLocation.Longitude]);

end;

procedure TdevFrm.lstZamowieniaDblClick(Sender: TObject);
var
  X, I: Integer;
begin

  for I := 0 to lstZamowienia.Items.Count - 1 do
    X := lstZamowienia.Selected.Index;

  _SELECTED_ORDER := _ORDER_LIST[X];
  ClearOrderChoice(true);

end;

procedure TdevFrm.lstZamowieniaItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  _SELECTED_ORDER := _ORDER_LIST[AItem.Index];
  ClearOrderChoice(true);
end;

procedure TdevFrm.PrepareImageURL;
var

  sSQL: String;
  X: Integer;
  ext: String;

  procedure Load(sName: String);
  begin

    Image2.Bitmap.LoadFromFile(sName);
    ImageViewer1.Bitmap.LoadFromFile(sName);

  end;

  procedure LoadSingleImage;
  var
    sPic: String;
  begin

    sPic := TPath.GetDocumentsPath + PathDelim + 'dev_cache' + PathDelim + 'full' + PathDelim + IntToStr(iGlobalTowarId) + ext;

    // spróbuj zaadowa lokalnie .....
    if (FileExists(sPic)) then
      Load(sPic)
    else
      // zacignij z URL i zaaduj
      if (not qryobrazkilink.AsString.IsEmpty) then
      begin
        if GetURLFile(qryobrazkilink.AsString, 'full', IntToStr(iGlobalTowarId) + ext) then
          Load(sPic);
      end;
  end;
//
//
//

begin

  Image2.Bitmap.Assign(nil);

  sSQL := 'SELECT * FROM `towarurl` WHERE `towarurl`.`towarid`=:_IDPOZ;';

  qryobrazki.Close;
  qryobrazki.SQL.Clear;
  qryobrazki.SQL.Text := sSQL;
  qryobrazki.Params.ParamByName('_IDPOZ').AsInteger := iGlobalTowarId;

  try

    qryobrazki.Active := true;

  except

    on e: Exception do
      _ErrorToFILE(e.Message);

  end;

  cbPicChoose.Clear;
  cbPicChoose.Items.Add('Wybierz z listy...');

  // nie ma nic - quit
  if qryobrazki.RecordCount = 0 then
  begin
    lblNoPic.Visible := true;
    Image2.Visible := false;
    qryobrazki.Active := false;
    exit;
  end;

  Image2.Visible := true;
  lblNoPic.Visible := not Image2.Visible;

  for X := 0 to qryobrazki.RecordCount - 1 do
  begin
    ext := GetURLExtension(qryobrazkilink.AsString);
    if (qryobrazkityp.AsString = 'O') AND (X = 0) then
      LoadSingleImage;
    cbPicChoose.Items.Add(IntToStr(iGlobalTowarId) + ext);
  end;

  cbPicChoose.ItemIndex := 1;

end;

function TdevFrm.GetURLExtension(sURL: String): String;
var
  s: String;

begin

  s := Copy(sURL, Length(sURL) - 2, 3);
  s := AnsiLowerCase(s);

  result := '.' + s;

end;

function TdevFrm.PrepareOrderToSend(sZnacznik, cAnuluj: Char): string;
var
  JO, JGN: TJSonObject;
  I, y: Integer;
  dn, qv: string;
  dtc: string; // data  czas dla danego zamowienia

begin

  y := 0;
  // MySQL nie dopuszcza daty takiej jak niej !!!! z :zzz
  // dtc := FormatDateTime('yyyy-mm-dd hh:nn:ss:zzz', Date() + Time());
  dtc := FormatDateTime('yyyy-mm-dd hh:nn:ss', Date() + Time());
  JGN := TJSonObject.Create;

  OpenTable_Order;
  qry_zamowienie.First;

    while  qry_zamowienie.Eof do
    begin


      JO := TJSonObject.Create;

      for I := 0 to qry_zamowienie.FieldCount - 1 do
      begin
        // bez autoinc
        // bez pól calculated
        if (qry_zamowienie.Fields[I].FieldKind = fkData) and (qry_zamowienie.Fields[I].DataType <> ftAutoInc) then
        begin
          dn := qry_zamowienie.Fields[I].DisplayName;
          qv := qry_zamowienie.Fields[I].AsString;

          if (dn = 'dataczas') then
            qv := dtc;

          if (cAnuluj = 'D') and (dn = 'realizacja') then
            qv := cAnuluj;

          if (dn = 'rodzajdok') then
            qv := sZnacznik;

          JO.AddPair(dn, qv);

        end;
      end;

      inc(y);
      qry_zamowienie.Next;
      JGN.AddPair(IntToStr(y), JO);

    end;

  result := JGN.ToJSON;
end;

procedure TdevFrm.TabControl1Change(Sender: TObject);

  procedure Tab3BTN(b: boolean);
  begin
    btnSendOrder.Enabled := b;
    btnQPrice.Enabled := b;
    btnAnulujZam.Enabled := not CzyWczytane_SERWER;
    btnDelPos.Enabled := false;
  end;

begin

  if TabControl1.ActiveTab.Index = 3 then
  begin

    GetCLICKEDProduct;
    PrepareImageURL;

  end;

  if TabControl1.ActiveTab.Index = 4 then
    if (GetMAXid_ZAM <= 0) then
      Tab3BTN(false)
    else
      Tab3BTN(true);

  if TabControl1.ActiveTab.Index = 5 then
  begin
    // jest zamówienie lokalne - wycz guzik
    if (GetMAXid_ZAM > 0) then
      showmessage('Masz niewysane zamówienie .Wczytanie kolejnego nie jest moliwe')
    else
    begin
      lstZamowienia.Items.Clear;
      ServerOrderRead;
    end;
    // btnShowAll.Enabled := true;

  end;

end;

procedure TdevFrm.TitleActionUpdate(Sender: TObject);
begin
  if Sender is TCustomAction then
  begin

    if TabControl1.ActiveTab <> nil then
      TCustomAction(Sender).Text := TabControl1.ActiveTab.Text
    else
      TCustomAction(Sender).Text := '';
  end;

end;

function TdevFrm.strGetPicLnkByID(sTyp: String; iNr: Integer): String;
var
  n: string;
begin

  qryobrazki.Close;
  qryobrazki.SQL.Clear;

  if sTyp <> '' then
    qryobrazki.SQL.Text := 'SELECT * FROM `towarurl` WHERE `towarurl`.`towarid`=:asNr;'
  else
  begin
    qryobrazki.SQL.Text := 'SELECT * FROM `towarurl` WHERE `towarurl`.`typ`=:asTyp and `towarurl`.`towarid`=:asNr;';
    qryobrazki.ParamByName('asTyp').AsString := sTyp;
  end;

  qryobrazki.ParamByName('asNr').AsInteger := iNr;

  try

    qryobrazki.Open;
    n := qryobrazkilink.AsString;

  except

    on e: Exception do
      showmessage(e.Message);

  end;

  result := n;

end;

procedure TdevFrm.MakePictureThumbs;

  procedure makeMini(sFName: String);
  var
    img: TImage;
    strImg: TResourceStream;
  begin
    img := TImage.Create(Self);
    img.Width := 90;
    img.Height := 90;

    strImg := TResourceStream.Create(HInstance, 'PngImage_1', RT_RCDATA);
    img.Bitmap.LoadFromStream(strImg);
    img.Bitmap.SaveToFile(TPath.GetDocumentsPath + PathDelim + 'dev_cache' + PathDelim + 'mini' + PathDelim + sFName);
    // czy nie powinno tu by free, nie byo
    // strImg.Free;

  end;

var
  sSQL: String;
  s: String;

begin

  sSQL := 'SELECT * FROM `towarurl` WHERE `towarurl`.`typ`=:asTyp;';

  qryobrazki.Close;
  qryobrazki.SQL.Clear;
  qryobrazki.SQL.Add(sSQL);
  qryobrazki.ParamByName('asTyp').AsString := 'I';
  qryobrazki.Active := true;

  try

    if (qryobrazki.Active) then
    begin
      qryobrazki.First;

      while not qryobrazki.Eof do
      begin

        s := qryobrazkilink.AsString;

        if not FileExists(TPath.GetDocumentsPath + PathDelim + 'dev_cache' + PathDelim + 'mini' + PathDelim + qryobrazkitowarid.AsString + GetURLExtension(s)) then
        begin
          if not s.IsEmpty then
          begin
            if GetURLFile(s, 'mini', qryobrazkitowarid.AsString + GetURLExtension(s)) = false then
              makeMini('mini' + PathDelim + qryobrazkitowarid.AsString + GetURLExtension(s));
          end;
        end;

        qryobrazki.Next;
      end;

    end;

  finally

  end;
end;

procedure TdevFrm.OpenTable_Dictionary;
var
  strImg: TResourceStream;
  Item: TListViewItem;
  img: TImage;
  sExt, sPlik: string;
  sSQL: String;
begin

  img := TImage.Create(Self);
  img.Width := 90;
  img.Height := 90;

  qry_towar.Close;
  qry_towar.SQL.Clear;
  // qry_towar.SQL.Add('PRAGMA synchronous=OFF;');
  // qry_towar.SQL.Add('SELECT * FROM towar ORDER BY index_name;');

  sSQL := 'SELECT ' + 'towar.id as id_towar,towar.indeks, towar.ean, towar.nazwa,' + 'towar.dostawca,towar.dostawcaid,towar.producent,towar.producentid,' + 'towar.data_mod,towar.jm,towar.cena,' +

    'regondostawca.id as id_regondostawca, ' + 'regondostawca.identyfikator as dostawcaidentyfikator,' + 'regondostawca.nazwa as dostawcanazwa,' + 'regondostawca.minimum,' +

    'regonproducent.id as id_regonproducent,' + 'regonproducent.identyfikator as producentidentyfikator,' + 'regonproducent.nazwa as producentnazwa' +

    ' FROM towar' + ' LEFT OUTER JOIN regon regondostawca ON towar.dostawcaid = regondostawca.id' + ' LEFT OUTER JOIN regon regonproducent ON towar.producentid = regonproducent.id;';

  // 'GROUP BY towar.nazwa ORDER BY towar.nazwa;';

  qry_towar.SQL.Add(sSQL);
  qry_towar.Active := true;

  strImg := TResourceStream.Create(HInstance, 'PngImage_1', RT_RCDATA);
  try

    if qry_towar.Active then
    begin

      qry_towar.First;

      while not qry_towar.Eof do
      begin

        // strGetPicLnkByID('I',qry_towarid_towar.AsInteger);

        // sExt := GetURLExtension(strGetPicLnkByID('I',qry_towarid_towar.AsInteger));

        sExt := '.jpg';

        sPlik := TPath.GetDocumentsPath + PathDelim + 'dev_cache' + PathDelim + 'mini' + PathDelim + qry_towarid_towar.AsString + sExt;

        application.ProcessMessages;

        try

          if (FileExists(sPlik)) then
            img.Bitmap.LoadFromFile(sPlik)
          else
            img.Bitmap.LoadFromStream(strImg);

        except

          img.Bitmap.LoadFromStream(strImg);

        end;

        with ListView4.Items.Add do
        begin
          // Data['TowarId'] := qry_towarid_towar.AsString;  // pole 'TowarId' do usunicia

          Data['Text1'] := qry_towarnazwa.AsString;

          // producent / dostawca
          if qry_towardostawcanazwa.AsString <> '' then
            Data['Detail1'] := qry_towardostawcanazwa.AsString + ' cena: ' + qry_towarcena.AsString + '/' + qry_towarjm.AsString
          else
            Data['Detail1'] := qry_towarproducentnazwa.AsString + ' cena: ' + qry_towarcena.AsString + '/' + qry_towarjm.AsString;

          Data['Portrait'] := img.Bitmap;

          Index := qry_towarid_towar.AsInteger;
          Tag := qry_towarid_towar.AsInteger;

        end;

        qry_towar.Next;
        img.Bitmap.Assign(nil);

      end; // while

    end;

  finally
    img.Free;
    strImg.Free;
  end

end;

// =============================================================================
// Obsuga dwóch guzików CENA i ZAMOWIENIE
//
// =============================================================================
procedure TdevFrm.btnSendOrderClick(Sender: TObject);
begin

  if GPS_CHECK = false then
  begin
    showmessage(_strERR_NOGPS);
    exit;
  end;

  if GetMAXid_ZAM > 0 then
  begin

    case (Sender as TButton).Tag of

      4020:
        begin

          if CzyWczytane_SERWER = true then
          begin
            showmessage('To zamówienie nie jest wczytane z serwera, nie mona go anulowa.');
            exit;
          end
          else
            QuestionYN(btnAnulujZam);
        end;

      45:
        QuestionYN(btnQPrice);
      50:
        QuestionYN(btnSendOrder);

    end;

  end;

end;

procedure TdevFrm.ServerOrderRead;
var
  IdHTTP: TIdHTTP;
  lParamList: TStringList;

  JO: TJSonObject;
  ilZ, X: Integer; // ilosc zamowien
  iCO: Integer;
  sJString: String;
  itm: TListViewItem;
  sBody: String;

begin

  if (GetMAXid_ZAM > 0) then
  begin

    showmessage('Masz niewysane zamówienie. Wczytanie nie jest moliwe');
    exit;

  end;

  ClearOrderChoice(false);

  lParamList := TStringList.Create;
  IdHTTP := TIdHTTP.Create;

  lParamList.Add('userid=' + __iGLOBAL_USER_ID.ToString);
  lParamList.Add('budowa=' + __sGLOBAL_CONSTR_NAME);

  try

    sJString := IdHTTP.Post('http://' + _sGLOBAL_IP_HOST + _sGLOBAL_HTTP_PORT + '/developer/d2php2d/show_my_orders.php', lParamList);

    JO := TJSonObject.Create;
    JO := TJSonObject.ParseJSONValue(sJString) as TJSonObject;

    ilZ := JO.GetValue('ilpoz').Value.ToInteger;

    // dla testów
    if JO.GetValue('body') <> nil then
      sBody := JO.GetValue('body').ToString;

    FillChar(_ORDER_LIST, SizeOf(_ORDER_LIST), 0);
    SetLength(_ORDER_LIST, ilZ);

    if (ilZ > 0) then
    begin
      // S zamówienia do wczytania
      ClearOrderChoice(true);
      for X := 1 to ilZ do
      begin

        _ORDER_LIST[X - 1] := JO.GetValue('dataczas' + X.ToString).Value;

        with lstZamowienia.Items.Add do
        begin
          if iCO >= 9 then
            iCO := 0;

          Data['Text1'] := Format('Z dnia: %s', [JO.GetValue('dataczas' + X.ToString).Value]);
          Data['Detail1'] := Format('pozycji: %d', [JO.GetValue('RecCont' + X.ToString).Value.ToInteger]);
          Data['Portrait'] := iCO;
          inc(iCO);
        end;

      end;

    end

    else
      showmessage('Nie ma zamówie do wczytania ');

  finally

    lParamList.Free;
    IdHTTP.Free;

  end;

end;

procedure TdevFrm.btnShowAllClick(Sender: TObject);
// var
// IdHTTP: TIdHTTP;
// lParamList: TStringList;
//
// JO: TJSonObject;
// ilZ, X: Integer; // ilosc zamowien
// iCO : Integer;
//
// sJString: String;
//
// itm: TListViewItem;

begin
  //
  // if (GetMAXid_ZAM > 0) then
  // begin
  //
  // showmessage('Masz niewysane zamówienie. Wczytanie nie jest moliwe');
  // exit;
  //
  // end;
  //
  // ClearOrderChoice(false);
  //
  // lParamList := TStringList.Create;
  // IdHTTP := TIdHTTP.Create;
  //
  // lParamList.Add('userid=' + __iGLOBAL_USER_ID.ToString);
  // lParamList.Add('budowa=' + __sGLOBAL_CONSTR_NAME);
  //
  // try
  //
  // sJString := IdHTTP.Post('http://' + _sGLOBAL_IP_HOST + _sGLOBAL_HTTP_PORT +
  // '/developer/d2php2d/show_my_orders.php', lParamList);
  //
  // JO := TJSonObject.Create;
  // JO := TJSonObject.ParseJSONValue(sJString) as TJSonObject;
  //
  //
  //
  // ilZ := JO.GetValue('ilpoz').Value.ToInteger;
  //
  // FillChar(_ORDER_LIST,SizeOf(_ORDER_LIST),0);
  // SetLength(_ORDER_LIST,iLZ);
  //
  // if (ilZ > 0) then  begin
  // S zamówienia do wczytania
  // ClearOrderChoice(true);
  // for X := 1 to ilZ do begin
  //
  // _ORDER_LIST[X-1]:=JO.GetValue('dataczas' + X.ToString).Value;
  //
  // with lstZamowienia.Items.Add do
  // begin
  // if iCO>=9 then iCO:=0;
  // Data['Text1'] := Format('Zamówienie z dnia : %s',[JO.GetValue('dataczas' + X.ToString).Value]);
  // Data['Detail1'] := Format('Ilo pozycji w zamówieniu : %d', [JO.GetValue('RecCont' + X.ToString).Value.ToInteger]);
  // Data['Portrait'] := iCO;
  // Inc(iCO);
  // end;
  //
  // end;
  //
  // end
  //
  // else  showmessage('Nie ma zamówie do wczytania ');
  //
  //
  //
  // finally
  //
  // lParamList.Free;
  // IdHTTP.Free;
  //
  // end;

end;

procedure TdevFrm.btnViewOrderClick(Sender: TObject);

var
  IdHTTP: TIdHTTP;
  lParamList: TStringList;
  sJString: String;

  X: Integer;

  JO: TJSonObject;
  sSQL, sSQLVal: string;
  sIl: String; // konwersja ilosci

  bChck: boolean;

begin

  JO := TJSonObject.Create;
  IdHTTP := TIdHTTP.Create;
  lParamList := TStringList.Create;

  lParamList.Add('userid=' + __iGLOBAL_USER_ID.ToString);
  lParamList.Add('zam=' + _SELECTED_ORDER);
  // lParamList.Add('zam=' + cbWybZam.Selected.Text);
  lParamList.Add('budowa=' + __sGLOBAL_CONSTR_NAME);

  sSQL := 'INSERT INTO `zamowienie_temp` (`dataczas`,`budowa`, `ilosc`,`jm`,`minimum`,`nazwa`)';
  sSQLVal := 'VALUES (:dataczas,:budowa,:ilosc,:jm,:minimum,:nazwa);';

  try
    sJString := IdHTTP.Post('http://' + _sGLOBAL_IP_HOST + _sGLOBAL_HTTP_PORT + '/developer/d2php2d/get_my_order.php', lParamList);

    JO := TJSonObject.ParseJSONValue(sJString) as TJSonObject;

    for X := 1 to JO.GetValue('ilpoz').Value.ToInteger do
    begin
      sIl := StringReplace(JO.GetValue('ilosc' + X.ToString).Value, '.', FormatSettings.DecimalSeparator, [rfReplaceAll]);
      with qryTempTable do
      begin
        Close;
        SQL.Clear;
        SQL.Add(sSQL);
        SQL.Add(sSQLVal);

        Params.ParamByName('budowa').AsString := JO.GetValue('budowa' + X.ToString).Value;

{$IFDEF ANDROID}
        Params.ParamByName('dataczas').AsString := JO.GetValue('dataczas' + X.ToString).Value;
{$ENDIF}
{$IFDEF MSWINDOWS}
        Params.ParamByName('dataczas').AsDateTime := VarToDateTime(JO.GetValue('dataczas' + X.ToString).Value);
{$ENDIF}
        Params.ParamByName('ilosc').AsFloat := ZamienStrToFloat(JO.GetValue('ilosc' + X.ToString).Value);
        Params.ParamByName('jm').AsString := JO.GetValue('jm' + X.ToString).Value;
        Params.ParamByName('nazwa').AsString := JO.GetValue('nazwa' + X.ToString).Value;
        Params.ParamByName('minimum').AsString := JO.GetValue('minimum' + X.ToString).Value;
      end;

      try

        qryTempTable.ExecSQL;
        bChck := true;

      except

        on e: Exception do
          showmessage(e.Message);

      end;

    end;

  finally

    lParamList.Free;
    IdHTTP.Free;

  end;

  if (bChck = true) then
  begin
    Open_TempOrder;
    // showmessage(_strGOrderOK);
    ClearOrderChoice(false);
    ExecuteAction(chTempZamowienie);

  end;

end;

procedure TdevFrm.btnwebCloseClick(Sender: TObject);
begin
  // WebBrowser1.Navigate('
  // WebBrowser1.Navigate('about:blank');
  // ImageViewer1.Bitmap.Assign(nil);
  ExecuteAction(chTabSzczegoly);

end;

procedure TdevFrm.GetNewPictures;
var

  JO: TJSonObject;
  X, ilpoz: Integer;

  IdHTTP: TIdHTTP;
  lParamList: TStringList;
  Json: String;

begin

  IdHTTP := TIdHTTP.Create;
  lParamList := TStringList.Create;

  lParamList.Add('budowa=' + __sGLOBAL_CONSTR_NAME);

  Json := (IdHTTP.Post('http://' + _sGLOBAL_IP_HOST + _sGLOBAL_HTTP_PORT + _sGLOBAL_GET_PICS, lParamList));

  ExecuteQUERY('DELETE FROM `towarurl`;', 'towarurl');

  JO := TJSonObject.Create;
  JO := TJSonObject.ParseJSONValue(Json) as TJSonObject;

  try
    ilpoz := JO.GetValue('ilpoz').Value.ToInteger;

    if (ilpoz = -1) then
      exit;

    FDTransaction.StartTransaction;

    qrInsert.SQL.Clear();
    qrInsert.SQL.Add('INSERT INTO `towarurl` (`id`,`towarid`,`typ`,`link`)');
    qrInsert.SQL.Add('VALUES (:asid,:astowarid, :astyp, :aslink)');

    qrInsert.Params.ArraySize := ilpoz + 1;

    for X := 0 to ilpoz do
    begin
      qrInsert.Params.Items[0].AsIntegers[X] := JO.GetValue('id' + X.ToString).Value.ToInteger;
      qrInsert.Params.Items[1].AsIntegers[X] := JO.GetValue('towarid' + X.ToString).Value.ToInteger;
      qrInsert.Params.Items[2].AsStrings[X] := JO.GetValue('typ' + X.ToString).Value;
      qrInsert.Params.Items[3].AsStrings[X] := JO.GetValue('link' + X.ToString).Value;
    end;

    qrInsert.Execute(ilpoz + 1);

  finally

    FDTransaction.Commit;
    IdHTTP.Free;
    lParamList.Free;

  end;

end;

function TdevFrm.ZamienStrToFloat(asWartosc: String): Extended;
var
  sWartosc: String;
begin

  sWartosc := StringReplace(asWartosc, '.', FormatSettings.DecimalSeparator, [rfReplaceAll]);
  result := StrToFloat(sWartosc);

end;

function TdevFrm.ZamienStrToDateTime(asWartosc: String): TDateTime;
// var
//
// dtData : TDateTime;
// dtCzas : TTime;
// sWartoscData : String;
// sWartoscCzas : String;

begin

  // dtData := VarToDateTime(asWartosc);

  // FormatDateTime('yyyy-mm-dd hh:nn:ss',StrToDateTime(asWartosc));
  //
  // sWartoscData := asWartosc.Substring(0, 10);
  // sWartoscCzas := asWartosc.Substring(11, 19);
  //
  // sWartoscData := StringReplace(sWartoscData, '-', FormatSettings.DateSeparator, [rfReplaceAll]);
  // sWartoscCzas := StringReplace(sWartoscCzas, ':', FormatSettings.TimeSeparator, [rfReplaceAll]);
  //
  // dtData := StrToDateTime(sWartoscData);
  // dtCzas := StrToTime(sWartoscCzas);
  //
  //
  // result := dtData + dtCzas;
  //
  // albo tak ( nie testowane )

  // result :=  FormatDateTime('yyyy-mm-dd hh:nn:ss',asWartosc);

end;

procedure TdevFrm.GetNewREGON;
var
  JO: TJSonObject;
  X, ilpoz: Integer;

  IdHTTP: TIdHTTP;
  lParamList: TStringList;

  Json: String;

begin

  IdHTTP := TIdHTTP.Create;
  lParamList := TStringList.Create;

  lParamList.Add('budowa=' + __sGLOBAL_CONSTR_NAME);

  Json := (IdHTTP.Post('http://' + _sGLOBAL_IP_HOST + _sGLOBAL_HTTP_PORT + _sGLOBAL_GET_REGON, lParamList));

  ExecuteQUERY('DELETE FROM `regon`;', 'regon');

  JO := TJSonObject.Create;
  JO := TJSonObject.ParseJSONValue(Json) as TJSonObject;

  try
    ilpoz := JO.GetValue('ilpoz').Value.ToInteger;

    if (ilpoz = -1) then
      exit;

    FDTransaction.StartTransaction;

    qrInsert.SQL.Clear();
    qrInsert.SQL.Add('INSERT INTO `regon` (`id`,`identyfikator`,`nazwa`,`minimum`,`DPO`)');
    qrInsert.SQL.Add('VALUES (:A, :B, :C, :D, :E)');

    qrInsert.Params.ArraySize := ilpoz + 1;

    for X := 0 to ilpoz do
    begin
      qrInsert.Params.Items[0].AsIntegers[X] := JO.GetValue('id' + X.ToString).Value.ToInteger;
      qrInsert.Params.Items[1].AsStrings[X] := JO.GetValue('identyfikator' + X.ToString).Value;
      qrInsert.Params.Items[2].AsStrings[X] := JO.GetValue('nazwa' + X.ToString).Value;
      qrInsert.Params.Items[3].AsFloats[X] := ZamienStrToFloat(JO.GetValue('minimum' + X.ToString).Value);
      qrInsert.Params.Items[4].AsStrings[X] := JO.GetValue('DPO' + X.ToString).Value;
    end;

    qrInsert.Execute(ilpoz + 1);

  finally

    FDTransaction.Commit;
    IdHTTP.Free;
    lParamList.Free;

  end;

end;

procedure TdevFrm.GetNewDictionary;

var
  JO: TJSonObject;
  X, ilpoz: Integer;
  IdHTTP: TIdHTTP;
  lParamList: TStringList;
  Json: String;

begin

  IdHTTP := TIdHTTP.Create;
  lParamList := TStringList.Create;

  lParamList.Add('dm=parametr_programu');
  Json := (IdHTTP.Post('http://' + _sGLOBAL_IP_HOST + _sGLOBAL_HTTP_PORT + _sGLOBAL_GET_DICT, lParamList));

  ExecuteQUERY('DELETE FROM `towar`;', 'towar');

  JO := TJSonObject.Create;
  JO := TJSonObject.ParseJSONValue(Json) as TJSonObject;

  try

    ilpoz := JO.GetValue('ilpoz').Value.ToInteger;

    if (ilpoz = -1) then
    begin

      ShowNotify('Baza towarowa równa zero !');
      exit;

    end;

    FDTransaction.StartTransaction;

    qrInsert.SQL.Clear();
    qrInsert.SQL.Add('INSERT INTO `towar` (`id`,`indeks`,`ean`,`nazwa`,`dostawca`,`dostawcaid`,`producent`,`producentid`,`data_mod`,`jm`,`cena`)');
    qrInsert.SQL.Add('VALUES (:id, :index, :ean, :nazwa, :dostawca, :dostawcaid, :producent, :producentid,:data_mod,:jm,:cena)');

    qrInsert.Params.ArraySize := ilpoz + 1;

    for X := 0 to ilpoz do
    begin
      qrInsert.Params.Items[0].AsIntegers[X] := JO.GetValue('id' + X.ToString).Value.ToInteger;
      qrInsert.Params.Items[1].AsStrings[X] := JO.GetValue('index' + X.ToString).Value;
      qrInsert.Params.Items[2].AsStrings[X] := JO.GetValue('ean' + X.ToString).Value;
      qrInsert.Params.Items[3].AsStrings[X] := JO.GetValue('nazwa' + X.ToString).Value;
      qrInsert.Params.Items[4].AsStrings[X] := JO.GetValue('dostawca' + X.ToString).Value;
      qrInsert.Params.Items[5].AsStrings[X] := JO.GetValue('dostawcaid' + X.ToString).Value;
      qrInsert.Params.Items[6].AsStrings[X] := JO.GetValue('producent' + X.ToString).Value;
      qrInsert.Params.Items[7].AsStrings[X] := JO.GetValue('producentid' + X.ToString).Value;
      // qrInsert.Params.Items[6].AsDateTimes[x]:= VarToDateTime(JO.GetValue('data_mod'+x.ToString).Value);
      // qrInsert.Params.Items[6].AsDateTimes[x]:= ZamienStrToDateTime(JO.GetValue('data_mod'+x.ToString).Value);

      qrInsert.Params.Items[8].AsStrings[X] := JO.GetValue('data_mod' + X.ToString).Value;

      qrInsert.Params.Items[9].AsStrings[X] := JO.GetValue('jm' + X.ToString).Value;
      qrInsert.Params.Items[10].AsFloats[X] := ZamienStrToFloat(JO.GetValue('cena' + X.ToString).Value);

    end;

    qrInsert.Execute(ilpoz + 1);

  finally

    FDTransaction.Commit;

    IdHTTP.Free;
    lParamList.Free;

  end;

end;

procedure TdevFrm.ExecuteQUERY(sCO: String; sTabela: String);

begin

  with qryUpdate

    do
  begin
    Close;
    SQL.Clear;
    SQL.Add(sCO);

    try

      ExecSQL;

    except
      on e: Exception do
      begin
        showmessage('Bd przy pobieraniu ' + sTabela + ' ' + e.Message);
        devFrm.Close;
      end;
    end;

    Close;
  end;

end;

{ ===============================================================================

  JSON,PHP,MySQL : Wysanie zamówienia na serwer

  =============================================================================== }

procedure TdevFrm.SendOrder(sParams: String);
var
  IdHTTP: TIdHTTP;
  lParamList: TStringList;
  Json: String;

begin

  lParamList := TStringList.Create;
  IdHTTP := TIdHTTP.Create;

  lParamList.Add('json=' + sParams);

  try
    Json := IdHTTP.Post('http://' + _sGLOBAL_IP_HOST + _sGLOBAL_HTTP_PORT + _sGLOBAL_ORDER_INS, lParamList);

    if JSONPHPAnswer(Json) = true then
    begin

      ClearOrder;
      showmessage(_strSOrderOK);

    end
    else
      showmessage(_strERR_SOrder);

  except
    on e: Exception do
      _ErrorToFILE(e.Message);

  end;

  IdHTTP.Free;
  lParamList.Free;

end;

procedure TdevFrm.Open_TempOrder;
begin

  qryTempTable.Close;
  qryTempTable.SQL.Clear;
  qryTempTable.SQL.Add('SELECT * FROM `zamowienie_temp`;');

  try

    qryTempTable.Open;

  except

    on e: Exception do
      _ErrorToFILE(e.Message, true);

  end;

end;

procedure TdevFrm.OpenTable_Order;
begin

  qry_zamowienie.Close;
  qry_zamowienie.SQL.Clear;
  qry_zamowienie.SQL.Add('SELECT * FROM `zamowienietowar` WHERE `zamowienietowar`.`zamawiajacy`=:userID AND `zamowienietowar`.`budowa`=:userCONS;');

  qry_zamowienie.Params.ParamByName('userID').AsInteger := __iGLOBAL_USER_ID;
  qry_zamowienie.Params.ParamByName('userCONS').AsString := __sGLOBAL_CONSTR_NAME;

  try

    qry_zamowienie.Open;

  except

    on e: Exception do
      _ErrorToFILE(e.Message);

  end;

end;

{


}
procedure TdevFrm.Button1Click(Sender: TObject);

var
  dlg: TfrmSettings;

begin

  dlg := TfrmSettings.Create(nil);
  dlg.Caption := 'ustawienia';

  dlg.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      // Showmessage('wpisano :' +dlg.edit1.text);
    end);

end;

procedure TdevFrm.btnChConsClick(Sender: TObject);
begin

  if (cbListaBudow.ItemIndex < 0) then
  begin

    showmessage('Budowa nie zostaa wybrana !');
    exit;

  end;

  __sGLOBAL_CONSTR_NAME := cbListaBudow.Selected.Text;

  paneBudowa.Visible := false;
  cbListaBudow.Clear;
  EnableButtons(true);
  ExecuteAction(tabMainMenu);

end;

function TdevFrm.GPS_CHECK: boolean;

var
  IdHTTP: TIdHTTP;
  lParamList: TStringList;

begin
  FormatSettings.DecimalSeparator := '.';

  IdHTTP := TIdHTTP.Create;
  lParamList := TStringList.Create;

  lParamList.Add('userid=' + __iGLOBAL_USER_ID.ToString);
  lParamList.Add('kodbudowy=' + __sGLOBAL_CONSTR_NAME);

  lParamList.Add('lat=' + FloatToStrF(_LAT, ffGeneral, 11, 7));
  lParamList.Add('lng=' + FloatToStrF(_LNG, ffGeneral, 11, 7));

  try

    try
      __bCAN_SEND_ORDER := JSONPHPAnswer(IdHTTP.Post('http://' + _sGLOBAL_IP_HOST + _sGLOBAL_HTTP_PORT + '/developer/d2php2d/gps_coords.php', lParamList));
    except

      on e: Exception do
      begin
        __bCAN_SEND_ORDER := false;
        _ErrorToFILE(e.Message, true);
      end;

    end;

  finally

    IdHTTP.Free;
    lParamList.Free;

  end;

  result := __bCAN_SEND_ORDER;

end;

procedure TdevFrm.btnZamowienieTmpZamknijClick(Sender: TObject);
begin
  With qryTempTable do
  begin

    Close;
    SQL.Clear;
    SQL.Add('DELETE FROM `zamowienie_temp`;');

    try

      ExecSQL;

    except

      on e: Exception do
        _ErrorToFILE(e.Message, true);

    end;

  end;
  ExecuteAction(chPokazMojeZam);
end;

procedure TdevFrm.cbPicChooseChange(Sender: TObject);
var
  s: String;

  fName: String;
{$IFDEF ANDROID}
  Intent: JIntent;
  URI: Jnet_Uri;
{$ENDIF}
begin
  if (cbPicChoose.ItemIndex = 0) then
    exit;

  ImageViewer1.Bitmap.Assign(nil);
  s := GetURLExtension(cbPicChoose.Selected.Text);

  fName := TPath.GetDocumentsPath + PathDelim + 'dev_cache' + PathDelim + 'full' + PathDelim + cbPicChoose.Selected.Text;
  // fName := TPath.GetSharedDownloadsPath + PathDelim + cbPicChoose.Selected.Text;

  if (s = '.pdf') then
  begin
{$IFDEF MSWINDOWS}
    showmessage('Funkcja tymczasowo nie jest obsugiwana w systemie Windows');
{$ENDIF}
{$IFDEF ANDROID}
    URI := TJnet_Uri.JavaClass.parse(StringToJString('file:///' + fName));
    Intent := TJIntent.Create;
    Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
    Intent.setDataAndType(URI, StringToJString('application/pdf'));
    TAndroidHelper.Activity.startActivity(Intent);
    // SharedActivity.startActivity(intent);

{$ENDIF}
  end;

  if (s = '.jpg') or (s = '.png') then
    ImageViewer1.Bitmap.LoadFromFile(fName);

end;

procedure TdevFrm.WszystkieBUTTON_YN(Sender: TObject);
begin

  case (Sender as TButton).Tag of

    6666:
      begin
        btnLogin.OnClick(Self);
        ExecuteAction(chTabLogowanie);
      end;

    666:
      QuestionYN(Sender);
    110:
      begin
        ClearProduct;
        ExecuteAction(ChangeTabLista);
      end;

    // USUNICIE POZYCJI z tabeli ZAMOWIENIA
    4010:
      QuestionYN(Sender);
    310:
      begin
        ClearProduct;
        ExecuteAction(tabMainMenu);
      end;

  end;
end;

//
//
//
//
procedure TdevFrm.QuestionYN(Sender: TObject);

var
  dlg: TMyModalForm;
  v: shortint;
  sJSon: String;
begin

  dlg := TMyModalForm.Create(nil);

  dlg.Caption := 'Pytanie';

  case (Sender as TButton).Tag of

    11:
      begin
        dlg.lblInfo.Text := 'Wylogowa ?';
        v := 111;
      end;

    666:
      begin
        dlg.lblInfo.Text := 'Zakoczy prac ?';
        v := 1;
      end;

    81:
      begin
        dlg.lblInfo.Text := 'Button5 Button45';
        v := 2;
      end;

    4010:
      begin
        dlg.lblInfo.Text := 'Usun pozycj?';
        v := 3;
      end;

    4020:
      begin
        dlg.lblInfo.Text := 'Anulowa zamówienie ?';
        v := 4;
      end;

    45:
      begin
        dlg.lblInfo.Text := 'Zapytanie o cen ?';
        v := 5;
      end;

    50:
      begin
        dlg.lblInfo.Text := 'Wysa zamówienie ?';
        v := 6;
      end;

  end;

  dlg.ShowModal(
    procedure(ModalResult: TModalResult)
    begin

      case (v) of

        111:
          if (ModalResult = 1) then
            User_Logout;

        1:
          if (ModalResult = 1) then
          begin
            User_Logout;
            Close;
          end;

        2:
          if (ModalResult = 1) then
            showmessage('Button5  OK')
          else
            showmessage('Button5 NIE OK');

        3:
          if (ModalResult = 1) then
          begin
            UsunPozycje;
            OpenTable_Order;
          end;

        4:
          begin
            if (ModalResult = 1) then
            begin

              sJSon := PrepareOrderToSend('Z', 'D');
              // zamowienie -Do anulowania
              SendOrder(sJSon);
            end;

          end;

        5:
          begin
            if (ModalResult = 1) then
            begin
              sJSon := PrepareOrderToSend('C', '#');
              SendOrder(sJSon);

            end;
          end;

        6:
          begin
            if (ModalResult = 1) then
            begin

              sJSon := PrepareOrderToSend('Z', '#');

              SendOrder(sJSon);

            end;
          end;

      end;

    end);
end;
//
//
//
//

procedure TdevFrm.btnAddOrderPosClick(Sender: TObject);

var
  sSQL, sSQLVal: String;

  sEAN, sINDEKSTOW, sNAZWA, sDOSTAWCA, sPRODUCENT, sIDENTYFIKATOR, sNAZWAREGON, sJM: String;

  iDOSTAWCA_ID, iPRODUCENT_ID, iID_REGON: Integer;
  iID_TOWAR, iMIN: Integer;

  dDATAMOD: TDateTime;

begin

  // if (edNazwa.Text = '') and (edTowarID.Text = '') then
  // begin
  // ExecuteAction(PreviousTabAction1);
  // exit;
  // end;

  sEAN := qry_towarean.AsString;

  iID_TOWAR := qry_towarid_towar.AsInteger;

  sINDEKSTOW := qry_towarindeks.AsString;

  sNAZWA := qry_towarnazwa.AsString;

  sJM := qry_towarjm.AsString;

  dDATAMOD := qry_towardata_mod.AsDateTime;

  sDOSTAWCA := qry_towardostawca.AsString;
  iDOSTAWCA_ID := qry_towardostawcaid.AsInteger;

  sPRODUCENT := qry_towarproducent.AsString;
  iPRODUCENT_ID := qry_towarproducentid.AsInteger;

  if qry_towarid_regondostawca.AsInteger = 0 then
    iID_REGON := qry_towarid_regonproducent.AsInteger
  else
    iID_REGON := qry_towarid_regondostawca.AsInteger;


  // if qry_towardostawcaidentyfikator.AsString='' then
  // sIDENTYFIKATOR := qry_towarproducentidentyfikator.AsString
  // else
  // sIDENTYFIKATOR := qry_towardostawcaidentyfikator.AsString;

  if qry_towarid_regondostawca.AsString = '' then
    sNAZWAREGON := qry_towarproducentnazwa.AsString
  else
    sNAZWAREGON := qry_towardostawcanazwa.AsString;

  iMIN := qry_towarminimum.AsInteger;

  sSQL := 'INSERT INTO `zamowienietowar`(`id`,  `dataczas`, `budowa`, `ilosc`,' + '`jm`,' + '`towarid`, `realizacja`, `zamawiajacy`, `nazwa_regon`, `minimum`,' +
    '`indeks`, `ean`, `nazwa`, `dostawca`, `dostawcaid`, `producent`,' + '`producentid`, `rodzajdok`,`DPO`,`data_mod`) ';

  sSQLVal := 'VALUES ( null,:dataczas,:budowa,:ilosc,:jm,' + ':towarid,:realizacja,:zamawiajacy,:nazwa_regon,:minimum,:indeks,' + ':ean,:nazwa,:dostawca,:dostawcaid,:producent,' +
    ':producentid,:rodzajdok,:DPO,:data_mod);';

  // ============================================================================
  // POLE `rodzajdok` wypeniane jest przy wysyaniu zamówienia / zapytania o cen
  // ============================================================================

  with qry_zamowienie do
  begin

    Close;
    SQL.Clear;
    SQL.Add(sSQL);
    SQL.Add(sSQLVal);

    Params.ParamByName('dataczas').Value := Now;

    Params.ParamByName('budowa').AsString := __sGLOBAL_CONSTR_NAME;
    Params.ParamByName('ilosc').AsFloat := spMinVal.Value;
    Params.ParamByName('jm').AsString := edJM.Text;
    // qry_szczegolyidtowar.AsInteger;
    // "realizacja" rozróniane jest w skrypcie i wg tego robiony jest
    // UPDATE lub iNSERT
    Params.ParamByName('towarid').AsInteger := iID_TOWAR;
    Params.ParamByName('realizacja').AsString := 'B';
    Params.ParamByName('zamawiajacy').AsInteger := __iGLOBAL_USER_ID;
    Params.ParamByName('nazwa_regon').AsString := sNAZWAREGON;
    Params.ParamByName('minimum').AsInteger := iMIN;

    Params.ParamByName('indeks').AsString := sINDEKSTOW;
    Params.ParamByName('ean').AsString := sEAN;
    Params.ParamByName('nazwa').AsString := sNAZWA;
    Params.ParamByName('dostawca').AsString := sDOSTAWCA;

    Params.ParamByName('dostawcaid').AsInteger := iDOSTAWCA_ID;
    Params.ParamByName('producent').AsString := sPRODUCENT;

    Params.ParamByName('producentid').AsInteger := iPRODUCENT_ID;
    Params.ParamByName('rodzajdok').AsString := 'Z'; // zamówienie

    Params.ParamByName('DPO').AsString := 'O'; // dodany na pa

    Params.ParamByName('data_mod').AsDateTime := dDATAMOD;

    try

      ExecSQL;

    except

      on e: Exception do
        _ErrorToFILE(e.Message, true);

    end;

    ExecuteAction(PreviousTabAction1);
    OpenTable_Order;

  end;

  ClearProduct;
end;

procedure TdevFrm.edUserMailKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin

  if Length(edUserMail.Text) > 7 then
    btnLogin.Visible := true;
end;

procedure TdevFrm.FDConAfterConnect(Sender: TObject);
begin

{$IFDEF TESTOWA}
  showmessage('Poczono FDCON');
{$ENDIF}
end;

procedure TdevFrm.FDConAfterDisconnect(Sender: TObject);
begin

{$IFDEF TESTOWA}
  showmessage('Poczenie zostao rozczone FDCON');
{$ENDIF}
end;

procedure TdevFrm.FDConBeforeConnect(Sender: TObject);

const
  dName = 'SQLite';

begin

  FDCon.DriverName := dName;

  try
    // C:\Users\%USERNAME%\Documents\
    FDCon.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, _sTblSlownikowa);

  except

    on e: Exception do
      _ErrorToFILE(e.Message, true);

  end;

end;

{ ===============================================================================

  FTP :              Poczenie

  ===============================================================================
  procedure TdevFrm.FTPConnect;
  begin

  IdFTP.Host := _sGLOBAL_IP_HOST;
  IdFTP.Port:= _iGLOBAL_IP_FTPPORT;
  IdFTP.UserName := _sGLOBAL_FTP_UName;
  IdFTP.Password := _sGLOBAL_FTP_UPass;

  try

  IdFTP.Connect;

  except
  on e:Exception do _ErrorToFILE(e.Message );

  end;

  end;

  {===============================================================================

  FTP :              Pobranie sFNAME

  ===============================================================================

  wyczona 2018-04-04


  procedure TdevFrm.GetFTPFile(sFName : String);

  begin

  try
  try
  IdFTP.Get(sFName,TPath.GetDocumentsPath + PathDelim +'dev_cache'+PathDelim+sFName,true);
  except
  on e:Exception do _ErrorToFILE(e.Message );
  end;

  finally
  IdFTP.Disconnect;
  end;

  end;

}
{ ===============================================================================

  HTTP :              Pobranie sFNAME po URL

  =============================================================================== }

function TdevFrm.GetURLFile(sUrlName, sSubDirectory, sLocalName: String): boolean;

var
  NetHTTPClient: TNetHTTPClient;
  NetHTTPRequest: TNetHTTPRequest;
  bStatus: boolean;
begin

  try

    NetHTTPClient := TNetHTTPClient.Create(application);
    NetHTTPRequest := TNetHTTPRequest.Create(application);
    NetHTTPRequest.Client := NetHTTPClient;
    NetHTTPRequest.OnRequestCompleted := NetHTTPRequestCompleted;
    NetHTTPRequest.OnRequestError := NetHTTPRequestError;

    asGlobalFileNameImage := TPath.GetDocumentsPath + PathDelim + 'dev_cache' + PathDelim + sSubDirectory + PathDelim + sLocalName;

    bStatus := true;

    try

      NetHTTPRequest.Get(sUrlName);

    except

      on e: Exception do
        bStatus := false;

    end;

  finally
    NetHTTPRequest.Free;
    NetHTTPClient.Free;
  end;

  result := bStatus;
end;

procedure TdevFrm.NetHTTPRequestError(const Sender: TObject; const AError: string);
begin
  // Synchronize(
  // procedure
  // begin
  // ShowResult(AError)
  // end);
end;

procedure TdevFrm.NetHTTPRequestCompleted(const Sender: TObject; const AResponse: IHTTPResponse);
var
  fs: TFileStream;
  sPath: String;
begin
  // TThread.Synchronize
  // (
  // nil,
  // procedure
  // var
  // fs: TFileStream;
  // begin
  fs := TFileStream.Create(asGlobalFileNameImage, fmCreate);
  AResponse.ContentStream.Position := 0;
  fs.CopyFrom(AResponse.ContentStream, AResponse.ContentStream.Size);
  fs.Free;
  // end
  // )
end;

procedure TdevFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin

{$IFDEF ANDROID}
  TAndroidHelper.Activity.finish;
  // SharedActivity.finish;
{$ELSE}
  Close;
{$ENDIF}
end;

procedure TdevFrm.FormCreate(Sender: TObject);

var
  sPath: String;

begin

  { This defines the default active tab at runtime }
  TabControl1.First(TTabTransition.None);

  sPath := TPath.GetDocumentsPath + PathDelim + 'dev_cache';

  if (not DirectoryExists(sPath)) then
  begin

    MkDir(sPath);
    MkDir(sPath + PathDelim + 'full');
    MkDir(sPath + PathDelim + 'mini');
    MkDir(sPath + PathDelim + 'karta');

  end;

  if ReadApplicationStyle = '' then
    SetStyle('Domylny')
  else
    SetStyle(ReadApplicationStyle);

end;

procedure TdevFrm.SetStyle(sParam: String);
var
  aStyle: TFmxObject;
  sPre: String;

  f: textfile;

begin

  case TOSVersion.Platform of

    pfWindows:
      sPre := 'Win';
    pfAndroid:
      sPre := 'And';

  end;

  if (sParam = 'Domylny') then
    sParam := 'Default';

  aStyle := nil;

  aStyle := TStyleManager.GetStyleResource(sPre + sParam);
  TStyleManager.SetStyle(aStyle);

  try

    AssignFile(f, TPath.GetDocumentsPath + PathDelim + 'style.set');
    Rewrite(f);
    Writeln(f, sParam);
    CloseFile(f);

  except

    on e: Exception do
      _ErrorToFILE(e.Message, true);

  end;

end;

function TdevFrm.ReadApplicationStyle: String;

var
  f: textfile;
  sStyl: string;

begin

  if (FileExists(TPath.GetDocumentsPath + PathDelim + 'style.set')) then
  begin

    try
      try

        AssignFile(f, TPath.GetDocumentsPath + PathDelim + 'style.set');
        Reset(f);
        Readln(f, sStyl);

      finally

        CloseFile(f);

      end;

    except
      on e: Exception do
        _ErrorToFILE(e.Message, true);
    end;

  end;

  if sStyl = '' then
    sStyl := 'Default';

  result := sStyl;

end;

procedure TdevFrm.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
// var
// sTab : String;
begin
  // sTab:=TabControl1.Tabs[TabControl1.TabIndex].Name;
  if Key = vkHardwareBack then // and (TabControl1.TabIndex <> 0) then
  begin
    TabControl1.ActiveTab := TabControl1.Tabs[TabControl1.TabIndex];
    Key := 0;
  end;
end;

procedure TdevFrm.FormResize(Sender: TObject);
begin
  gZamowienie.Columns[0].Width := btnListaTowarow.Width - gZamowienie.Columns[1].Width - gZamowienie.Columns[2].Width;

  gZamowienieTmp.Columns[1].Width := btnZamowienieTmpZamknij.Width - gZamowienie.Columns[0].Width - gZamowienie.Columns[2].Width - gZamowienie.Columns[3].Width;
end;

procedure TdevFrm.FormShow(Sender: TObject);
begin

  __CNT := 0;

{$IFDEF TESTOWA}
  showmessage('Praca na :' + _sGLOBAL_IP_HOST);
{$ENDIF}
  edUserMail.Text := _sGLOBAL_LOGIN_USER;
  edUserPass.Text := _sGLOBAL_LOGIN_PASS;

  if (not edUserMail.Text.IsEmpty and not edUserPass.Text.IsEmpty) then
    btnLoginClick(Sender);

end;

function TdevFrm.CzyWczytane_SERWER: boolean;

begin

  if qry_zamowienierodzajdok.AsString = 'Z' then
    result := false
  else
    result := true;

end;

procedure TdevFrm.btnDelPosClick(Sender: TObject);
begin

  if GetMAXid_ZAM <= 0 then
    exit;

  if GetMAXid_ZAM > 0 then
    WszystkieBUTTON_YN(btnDelPos);

  btnDelPos.Enabled := false;

end;

procedure TdevFrm.UruchomPdf(sPdf, sFilename: String);
var
  Intent: JIntent;
  fsRead: TFileStream;
  fsWrite: TFileStream;
  sDownloadFile: String;

begin
{$IFDEF MSWINDOWS}
  ShellExecute(0, 'OPEN', PChar(sPdf), '', '', SW_SHOWNORMAL);
{$ENDIF MSWINDOWS}
  // {$IFDEF POSIX}
{$IFDEF ANDROID}
  sDownloadFile := TPath.GetSharedDownloadsPath + PathDelim + sFilename;

  fsRead := TFileStream.Create(sPdf, fmOpenRead);
  fsWrite := TFileStream.Create(sDownloadFile, fmCreate);

  fsWrite.CopyFrom(fsRead, fsRead.Size);

  fsWrite.Free;
  fsRead.Free;

  Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
  Intent.setDataAndType(StrToJURI('file://' + sDownloadFile), StringToJString('application/pdf'));
  SharedActivity.startActivity(Intent);

{$ENDIF ANDROID}
  // _system(MarshaledAString('open ' + sPdf));
  // {$ENDIF POSIX}
end;

procedure TdevFrm.btnKartaProdClick(Sender: TObject);
var
  sPdf, sSQL, sExt, sFilename: String;
begin

  sExt := '.pdf';

  sPdf := TPath.GetDocumentsPath + PathDelim + 'dev_cache' + PathDelim + 'karta' + PathDelim + IntToStr(iGlobalTowarId) + sExt;
  sFilename := IntToStr(iGlobalTowarId) + sExt;

  // spróbuj zaadowa lokalnie .....
  if (FileExists(sPdf)) then
    UruchomPdf(sPdf, sFilename)
  else
  begin
    // zacignij z URL i zaaduj
    sSQL := 'SELECT * FROM towarurl WHERE typ=:asTyp AND towarid=:iTowarId';

    qryobrazki.Close;
    qryobrazki.SQL.Clear;
    qryobrazki.SQL.Add(sSQL);
    qryobrazki.ParamByName('asTyp').AsString := 'K';
    qryobrazki.ParamByName('iTowarId').AsInteger := iGlobalTowarId;

    qryobrazki.Open;

    if (not qryobrazkilink.AsString.IsEmpty) then
    begin
      if GetURLFile(qryobrazkilink.AsString, 'karta', IntToStr(iGlobalTowarId) + sExt) then
        UruchomPdf(sPdf, sFilename);
    end;

    qryobrazki.Close;
  end;
end;

procedure TdevFrm.UsunPozycje;
var
  s: string;
begin

  s := 'DELETE FROM `zamowienietowar` WHERE `zamowienietowar`.`id` =:zamowienie AND `zamowienietowar`.`zamawiajacy` =:nr;';

  qry_zamowienie.Close;
  qry_zamowienie.SQL.Clear;
  qry_zamowienie.SQL.Add(s);

  qry_zamowienie.Params.ParamByName('zamowienie').AsInteger := __iGLOBAL_ID_ZAM;
  qry_zamowienie.Params.ParamByName('nr').AsInteger := __iGLOBAL_USER_ID;

  try

    qry_zamowienie.ExecSQL;

  except

    on e: Exception do
      _ErrorToFILE(e.Message);

  end;

end;

procedure TdevFrm.btnListaTowarowClick(Sender: TObject);
begin
  ExecuteAction(ChangeTabLista);
end;

procedure TdevFrm.btnLoginClick(Sender: TObject);
var
  IdHTTP: TIdHTTP;
  lParamList: TStringList;
  Json: string;

begin

  // ================================================

  if (btnLogin.Tag = 11) then
  begin
    User_Logout;
    exit;
  end;

  IdHTTP := TIdHTTP.Create;
  lParamList := TStringList.Create;

  lParamList.Add('email=' + edUserMail.Text);
  lParamList.Add('haslo=' + edUserPass.Text);

  Json := (IdHTTP.Post('http://' + _sGLOBAL_IP_HOST + _sGLOBAL_HTTP_PORT + _sGLOBAL_USER_SCRIPT, lParamList));

  try
    if (USER_Login(Json) = true) then
    begin
      btnLogin.Enabled := false;
      Prepare;
    end
    else
      showmessage('Nieprawidowe dane logowania');

  finally

    IdHTTP.Free;
    lParamList.Free;

  end;



  // EnableButtons(FDCon.Connected);

  // sprzwdz gotowe do odebrania , planowana dostawa {zamowienie/a }...
  // timer interval = 1 godz.

end;

procedure TdevFrm.btnMojeZamClick(Sender: TObject);
begin
  ExecuteAction(chPokazMojeZam);
end;

procedure TdevFrm.btnMyOrderClick(Sender: TObject);
begin

  ExecuteAction(ChangeTabAction1);

end;

procedure TdevFrm.btnReadOrderClick(Sender: TObject);

var
  IdHTTP: TIdHTTP;
  lParamList: TStringList;
  sJString: String;

  X: Integer;

  JO: TJSonObject;
  sSQL, sSQLVal: string;
  sIl: String; // konwersja ilosci

  bChck: boolean;

begin

  JO := TJSonObject.Create;
  IdHTTP := TIdHTTP.Create;
  lParamList := TStringList.Create;

  lParamList.Add('userid=' + __iGLOBAL_USER_ID.ToString);
  lParamList.Add('zam=' + _SELECTED_ORDER);
  // lParamList.Add('zam=' + cbWybZam.Selected.Text);
  lParamList.Add('budowa=' + __sGLOBAL_CONSTR_NAME);

  sSQL := 'INSERT INTO `zamowienietowar`(`id`,  `dataczas`, `budowa`, `ilosc`, `jm`,' + '`towarid`, `realizacja`, `zamawiajacy`, `nazwa_regon`, `minimum`, `DPO`,' +
    '`indeks`, `ean`, `nazwa`, `dostawca`, `dostawcaid`, `producent`,' + '`producentid`, `data_mod`,`rodzajdok`) ';

  sSQLVal := 'VALUES ( :id,:dataczas,:budowa,:ilosc,:jm,' + ':towarid,:realizacja,:zamawiajacy,:nazwa_regon,:minimum,:DPO,' + ':indeks,:ean,:nazwa,:dostawca,:dostawcaid,:producent,' +
    ':producentid,:ddm,:rodzajdok);';

  try

    sJString := IdHTTP.Post('http://' + _sGLOBAL_IP_HOST + _sGLOBAL_HTTP_PORT + '/developer/d2php2d/get_my_order.php', lParamList);

    JO := TJSonObject.ParseJSONValue(sJString) as TJSonObject;

    for X := 1 to JO.GetValue('ilpoz').Value.ToInteger do
    begin

      // sIl := StringReplace(JO.GetValue('ilosc'+x.ToString).Value,'.',',',[rfReplaceAll]);
      // sIl := StringReplace(JO.GetValue('ilosc' + X.ToString).Value, '.',
      // FormatSettings.DecimalSeparator, [rfReplaceAll]);

      with qry_zamowienie do
      begin
        Close;
        SQL.Clear;
        SQL.Add(sSQL);
        SQL.Add(sSQLVal);

        Params.ParamByName('id').AsInteger := JO.GetValue('id' + X.ToString).Value.ToInteger;
{$IFDEF ANDROID}
        Params.ParamByName('dataczas').AsString := JO.GetValue('dataczas' + X.ToString).Value;
{$ENDIF}
{$IFDEF MSWINDOWS}
        Params.ParamByName('dataczas').AsDateTime := VarToDateTime(JO.GetValue('dataczas' + X.ToString).Value);
{$ENDIF}
        Params.ParamByName('budowa').AsString := JO.GetValue('budowa' + X.ToString).Value;

        Params.ParamByName('ilosc').AsFloat := ZamienStrToFloat(JO.GetValue('ilosc' + X.ToString).Value);

        Params.ParamByName('jm').AsString := JO.GetValue('jm' + X.ToString).Value;

        Params.ParamByName('towarid').AsInteger := JO.GetValue('towarid' + X.ToString).Value.ToInteger;
        Params.ParamByName('realizacja').AsString := JO.GetValue('realizacja' + X.ToString).Value;
        Params.ParamByName('zamawiajacy').AsInteger := JO.GetValue('zamawiajacy' + X.ToString).Value.ToInteger;
        Params.ParamByName('nazwa_regon').AsString := JO.GetValue('nazwa_regon' + X.ToString).Value;
        Params.ParamByName('minimum').AsInteger := JO.GetValue('minimum' + X.ToString).Value.ToInteger;
        Params.ParamByName('DPO').AsString := JO.GetValue('DPO' + X.ToString).Value;

        Params.ParamByName('indeks').AsString := JO.GetValue('indeks' + X.ToString).Value;
        Params.ParamByName('ean').AsString := JO.GetValue('ean' + X.ToString).Value;
        Params.ParamByName('nazwa').AsString := JO.GetValue('nazwa' + X.ToString).Value;
        Params.ParamByName('dostawca').AsString := JO.GetValue('dostawca' + X.ToString).Value;

        Params.ParamByName('dostawcaid').AsInteger := JO.GetValue('dostawcaid' + X.ToString).Value.ToInteger;
        Params.ParamByName('producent').AsString := JO.GetValue('producent' + X.ToString).Value;
        Params.ParamByName('producentid').AsInteger := JO.GetValue('producentid' + X.ToString).Value.ToInteger;
{$IFDEF ANDROID}
        Params.ParamByName('ddm').AsString := JO.GetValue('data_mod' + X.ToString).Value;
{$ENDIF}
{$IFDEF MSWINDOWS}
        Params.ParamByName('ddm').AsDateTime := VarToDateTime(JO.GetValue('data_mod' + X.ToString).Value);
{$ENDIF}
        Params.ParamByName('rodzajdok').AsString := JO.GetValue('rodzajdok' + X.ToString).Value;

      end;

      try

        qry_zamowienie.ExecSQL;
        SkasujPobrane_SERWER(JO.GetValue('id' + X.ToString).Value.ToInteger);
        bChck := true;

      except

        on e: Exception do
          showmessage(e.Message);

      end;

    end;

  finally

    lParamList.Free;
    IdHTTP.Free;

  end;

  if (bChck = true) then
  begin
    // showmessage(_strGOrderOK);
    ClearOrderChoice(false);

    ExecuteAction(PreviousTabAction1);
    OpenTable_Order;

  end;

end;

procedure TdevFrm.EnableButtons(bEnabled: boolean);
begin

  btnMListaTowarow.Enabled := bEnabled;
  btnMojeZam.Enabled := bEnabled;
  btnMyOrder.Enabled := bEnabled;

  if (__sGLOBAL_CONSTR_NAME = '') then
    exit;

  if bEnabled then
  begin
    btnLogin.Enabled := bEnabled;
    btnLogin.Tag := 11;
    btnLogin.Text := 'Wyloguj';
    btnLogin.ImageIndex := 2;
  end;

end;

procedure TdevFrm.SkasujPobrane_SERWER(iNr: Integer);
var
  IdHTTP: TIdHTTP;
  lParamList: TStringList;

begin

  IdHTTP := TIdHTTP.Create;
  lParamList := TStringList.Create;
  lParamList.Add('DEL=' + iNr.ToString);

  try
    IdHTTP.Post('http://' + _sGLOBAL_IP_HOST + _sGLOBAL_HTTP_PORT + '/developer/d2php2d/delete_order.php', lParamList);
  finally
    IdHTTP.Free;
    lParamList.Free;
  end;

end;

procedure TdevFrm.SpeedButton1Click(Sender: TObject);

var
  dlg: TfrmSettings;

begin

  dlg := TfrmSettings.Create(nil);
  dlg.Caption := 'ustawienia';

  dlg.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      // Showmessage('wpisano :' +dlg.edit1.text);
    end);
end;

procedure TdevFrm.SpeedButton2Click(Sender: TObject);
begin
  User_Logout;
  Close;
end;

procedure TdevFrm.ShowNotify(sNotka: String);
var
  notka: TNotification;

begin

  notka := NotificationCenter1.CreateNotification;

  try
    Sleep(1000);
    notka.Number := 1;
    notka.AlertBody := sNotka;
    NotificationCenter1.PresentNotification(notka);

  finally

    notka.DisposeOf;

  end;
end;

procedure TdevFrm.ShowResult(const ResultText: string);
begin
  // mKomunikaty.Lines.Add(ResultText);
end;

procedure TdevFrm.InfoPobieranieDanych(fNazwa: String);
// var
begin
  // System.Classes.TThread.Synchronize(
  // procedure
  // begin
  // ShowResult('ssss');
  // end);
end;

procedure TdevFrm.Prepare;
var
  f: textfile;
  fNazwa: String;
  // tKomunikaty: TGetThread;

  // sBud: String;
  // iName: Integer;



  // najchtniej zrobibym to w tabeli na serwerze

  // function Check_if_update: Boolean;
  // begin
  //
  // fNazwa := TPath.Combine(TPath.GetDocumentsPath,
  // FormatDateTime('yyyymmdd', Date));
  //
  // if (FileExists(fNazwa)) then
  // begin
  //
  // try
  // AssignFile(f, fNazwa);
  //
  // Reset(f);
  // Readln(f, sBud);
  // Readln(f, iName);
  //
  // finally
  // CloseFile(f);
  // end;
  //
  // end;
  //
  // if (sBud = __sGLOBAL_CONSTR_NAME) and (iName = __iGLOBAL_USER_ID) then
  // result := false
  // else
  // result := true;
  //
  // end;

begin

  FDConnect(true);

  if (FDCon.Connected = true) then
  begin
    CreateTable();

    if (DataAktualizacjiSlownikow() < Now() - 20) then
    begin
      // if (Check_if_update = true) then

      // Panel1.Visible := true;
      // TThreadProc;
      //

      // tKomunikaty := TGetThread.Create('sownik towarów', mKomunikaty);
      // tKomunikaty.Start;
      // InfoPobieranieDanych('sownik towarów');
      GetNewDictionary;

      // tKomunikaty := TGetThread.Create('sownik ikon i obrazów', mKomunikaty);
      // tKomunikaty.Start;
      // InfoPobieranieDanych('sownik ikon i obrazów');
      GetNewPictures;

      // tKomunikaty := TGetThread.Create('sownik podmiotów', mKomunikaty);
      // tKomunikaty.Start;
      // InfoPobieranieDanych('sownik podmiotów');
      GetNewREGON;

      // tKomunikaty := TGetThread.Create('obrazy', mKomunikaty);
      // tKomunikaty.Start;
      // InfoPobieranieDanych('obrazy');

      MakePictureThumbs;
      // OpenTable_Dictionary;

      UpdatePobranieSlownikow();
    end;

    EnableButtons(true);

    OpenTable_Dictionary;

    if (LocationSensor1.Active = false) then
      LocationSensor1.Active := true;

  end
  else
  begin
    FDConnect(false);
    showmessage('Z powodu bdu dalsza praca nie jest moliwa');
    exit;
  end;

end;
// ==============================================================================

// Wtki info na panel

// ==============================================================================
procedure TdevFrm.TThreadProc;
begin

  TThread.CreateAnonymousThread(
    procedure()
    var
      I: Integer;
    begin

      for I := 1 to 100 do
      begin

        TThread.Synchronize(TThread.CurrentThread,
          procedure()
          begin
            ProgressBar1.Value := I;
            Label3.Text := Format('pobrano : %d %', [I]);
            if I < 70 then
              Label2.Text := 'Pobieram towary';
            Sleep(100);
          end);

        TThread.Synchronize(TThread.CurrentThread,
          procedure()
          begin
            if (I > 85) then
              Label2.Text := 'Pobieram obrazki';
          end);

        TThread.Synchronize(TThread.CurrentThread,
          procedure()
          begin
            if (I > 95) then
              Label2.Text := 'Pobieram inne dane';
          end);

        TThread.Synchronize(TThread.CurrentThread,
          procedure()
          begin
            if (I >= 100) then
            begin
              Label2.Text := 'Koniec pobierania';
              // ExecuteQUERY('VACUUM;', '');
              Sleep(2000);
            end;
          end);
      end;

      TThread.Synchronize(TThread.CurrentThread,
        procedure()
        begin
          Panel1.Visible := false;
        end);
    end).Start;

end;

procedure TdevFrm.User_Logout;
begin

  btnLogin.Tag := 10;
  btnLogin.Text := 'Zaloguj';
  btnLogin.ImageIndex := 7;

  __iGLOBAL_USER_ID := -1;
  __sGLOBAL_CONSTR_NAME := 'N/D';

  edUserMail.Text := '';
  edUserPass.Text := '';

  EnableButtons(false);
  FDConnect(false);
  LocationSensor1.Active := false;

end;

procedure TdevFrm.FDConnect(bConn: boolean);
begin

  if FileExists(TPath.Combine(TPath.GetDocumentsPath, _sTblSlownikowa)) then
  begin

    try
      FDCon.Connected := bConn;
    except

      on e: Exception do
      begin
        _ErrorToFILE(e.Message, true);
        Close;
      end;

    end
  end

end;

{ ===============================================================================

  Zapis bdu do pliku TXT w katalogu domowym

  =============================================================================== }
procedure TdevFrm._ErrorToFILE(sErr: String; bShow: boolean = true);
var
  TF: textfile;
begin
{$I+}
  AssignFile(TF, GetHomePath + PathDelim + DateToStr(Date) + '_errorlog.log');
  if not FileExists(GetHomePath + PathDelim + DateToStr(Date) + '_errorlog.log') then
    Rewrite(TF)
  else
    Append(TF);

  Writeln(TF, sErr);
  Flush(TF);
  CloseFile(TF);

  if (bShow) then
    showmessage(sErr);
{$I-}
end;

procedure TdevFrm.qryTempTableCalcFields(DataSet: TDataSet);
begin

  if qryTempTableminimum.AsInteger > qryTempTableilosc.AsInteger then
    qryTempTableML.AsBoolean := false
  else
    qryTempTableML.AsBoolean := true;

  qryTempTableC_Ilosc.AsFloat := qryTempTableilosc.AsFloat;

end;

procedure TdevFrm.qry_zamowienieCalcFields(DataSet: TDataSet);
begin

  if qry_zamowienieminimum.AsInteger > qry_zamowienieilosc.AsInteger then
    qry_zamowienieML.AsBoolean := false
  else
    qry_zamowienieML.AsBoolean := true;

  qry_zamowienieC_ilosc.AsFloat := qry_zamowienieilosc.AsFloat;

end;

{ =============================================================================

  Czy s jakie pozycje w zamówieniu ?

  =============================================================================== }
function TdevFrm.GetMAXid_ZAM: Integer;
var
  r: Integer;
begin

  r := -1;
  qry_zamowienie.SQL.Text := 'SELECT * FROM `zamowienietowar` WHERE zamawiajacy=:zam AND budowa=:budowa';

  qry_zamowienie.Params.ParamByName('zam').AsInteger := __iGLOBAL_USER_ID;
  qry_zamowienie.Params.ParamByName('budowa').AsString := __sGLOBAL_CONSTR_NAME;

  try
    qry_zamowienie.Open;
    r := qry_zamowienie.RecordCount;
  except
    on e: Exception do
      showmessage(e.Message);

  end;

  result := r;

end;

{
  Pobranie ID zamowienia
}
// procedure TdevFrm.Grid1CellClick(const Column: TColumn; const Row: Integer);
// begin
// __iGLOBAL_ID_ZAM := qry_zamowienieidzam.AsInteger;
// btnDelPos.Enabled := __iGLOBAL_ID_ZAM <>-1;
// end;




// procedure TdevFrm.Grid1DrawColumnCell(Sender: TObject; const Canvas: TCanvas;
// const Column: TColumn; const Bounds: TRectF; const Row: Integer;
// const Value: TValue; const State: TGridDrawStates);
// var
// aRowColor: TBrush;
// begin

// aRowColor := Tbrush.Create(TBrushKind.Gradient,TAlphaColors.Alpha);
//
// if Value.ToString = 'True' then
// begin
//
// aRowColor.Color := TAlphaColors.Green;
// Canvas.FillRect(Bounds, 0, 0, [], 1, aRowColor);
// Column.DefaultDrawCell(Canvas, Bounds, Row, Value, State);
//
// end;
//
// if Value.ToString = 'False' then
// begin
//
// aRowColor.Color := TAlphaColors.Red;
// Canvas.FillRect(Bounds, 0, 0, [], 1, aRowColor);
// Column.DefaultDrawCell(Canvas, Bounds, Row, Value, State);
//
// end;
//
// aRowColor.free;

// end;

procedure TdevFrm.Image2Click(Sender: TObject);
begin
  ExecuteAction(chFullPic);
end;

procedure TdevFrm.Image2Tap(Sender: TObject; const Point: TPointF);
begin

  // Image2.Bitmap.Assign(nil);
  ExecuteAction(chTabSzczegoly);

end;

function TdevFrm.USER_Login(sJString: String): boolean;
var
  JO: TJSonObject;
  X, ilpoz: shortint;

begin

  __iGLOBAL_USER_ID := -1;

  JO := TJSonObject.Create;
  JO := TJSonObject.ParseJSONValue(sJString) as TJSonObject;

  try
    ilpoz := JO.GetValue('ilpoz').Value.ToInteger;
    __iGLOBAL_USER_ID := JO.GetValue('id').Value.ToInteger;

    // tylko jedna budowa ....
    if (ilpoz = 1) then
    begin
      __sGLOBAL_CONSTR_NAME := JO.GetValue('kod').Value;
      EnableButtons(true);
      ExecuteAction(tabMainMenu);

    end;

    // wicej ni jedna budowa
    if (ilpoz > 1) then
    begin
      paneBudowa.Visible := true;

      for X := 1 to ilpoz do
        cbListaBudow.Items.Add(JO.GetValue('kod' + X.ToString).Value);

    end;

  except
    on e: Exception do
      _ErrorToFILE(e.Message);
  end;

  JO.Free;

  if __iGLOBAL_USER_ID = -1 then
    result := false
  else
    result := true;

end;

procedure TdevFrm.gZamowienieCellClick(const Column: TColumn; const Row: Integer);
begin

  __iGLOBAL_ID_ZAM := qry_zamowienieid.AsInteger;
  btnDelPos.Enabled := __iGLOBAL_ID_ZAM <> -1;

end;

procedure TdevFrm.gZamowienieTap(Sender: TObject; const Point: TPointF);
begin

  __iGLOBAL_ID_ZAM := qry_zamowienieid.AsInteger;
  btnDelPos.Enabled := __iGLOBAL_ID_ZAM <> -1;

end;

{ ==============================================================================

  Zapytanie do tabeli wykonany poprawnie lub niepoprawnie

  =============================================================================== }
function TdevFrm.JSONPHPAnswer(sJString: String): boolean;
var
  JO: TJSonObject;
  bAnswr: boolean;
  sBody: String;

begin

  JO := TJSonObject.Create;
  JO := TJSonObject.ParseJSONValue(sJString) as TJSonObject;

  try

    bAnswr := JO.GetValue('result').Value.ToBoolean;

    // dla testów
    if JO.GetValue('body') <> nil then
      sBody := JO.GetValue('body').ToString;

  except

    on e: Exception do
      _ErrorToFILE(e.Message, false);

  end;

  result := bAnswr;

end;

{ ==============================================================================

  Wyczyszczenie tabeli ZAMOWIENIE lokalnie !

  =============================================================================== }

procedure TdevFrm.ClearOrder;
begin

  With qry_zamowienie do
  begin

    Close;
    SQL.Clear;
    SQL.Add('DELETE FROM `zamowienietowar` WHERE `zamawiajacy`=:idZam AND `budowa`=:BUD;');
    Params.ParamByName('idZam').AsInteger := __iGLOBAL_USER_ID;
    Params.ParamByName('BUD').AsString := __sGLOBAL_CONSTR_NAME;

    try

      ExecSQL;

    except

      on e: Exception do
        _ErrorToFILE(e.Message);

    end;

  end;

end;

procedure TdevFrm.ClearOrderChoice(bONOFF: boolean);
begin

  if bONOFF = false then
  begin

    lstZamowienia.ItemIndex := -1;
    _SELECTED_ORDER := '';

  end;

  btnReadOrder.Enabled := bONOFF;
  btnViewOrder.Enabled := bONOFF;

end;

function TdevFrm.TableExists(sTable: String): boolean;
var
  tbTablca: TFDTable;
  bExists: boolean;

begin
  tbTablca := TFDTable.Create(Self);

  tbTablca.Connection := FDCon;

  tbTablca.TableName := sTable;

  bExists := tbTablca.Exists;

  tbTablca.Free;

  result := bExists;
end;

procedure TdevFrm.CreateTableTest();
var
  qrTablca: TFDQuery;

begin
  qrTablca := TFDQuery.Create(Self);

  qrTablca.Connection := FDCon;

  qrTablca.SQL.Clear;
  qrTablca.SQL.Add('CREATE TABLE `test` (' + '`id` int(6) NOT NULL,' + '`nazwa` varchar(255) NOT NULL,' + '`dataimp` datetime NOT NULL' + ')');

  qrTablca.ExecSQL;

  qrTablca.Free;
end;

procedure TdevFrm.AddPobranieSlownikow();
var
  qrTablca: TFDQuery;

begin
  qrTablca := TFDQuery.Create(Self);
  qrTablca.Connection := FDCon;
  qrTablca.SQL.Clear;
  qrTablca.SQL.Add('INSERT INTO `test` ' + '(id, nazwa, dataimp) ' + 'VALUES (:iid, :snazwa, :dtdataimp)');
  qrTablca.Params.Items[0].AsInteger := 1;
  qrTablca.Params.Items[1].AsString := 'pobieranie sowników';
  qrTablca.Params.Items[2].AsDateTime := EncodeDate(1900, 1, 1);
  qrTablca.ExecSQL;
  qrTablca.Free;
end;

procedure TdevFrm.UpdatePobranieSlownikow();
var
  qrTablca: TFDQuery;

begin
  qrTablca := TFDQuery.Create(Self);
  qrTablca.Connection := FDCon;
  qrTablca.SQL.Clear;
  qrTablca.SQL.Add('UPDATE `test` ' + 'SET dataimp=:dtdataimp ' + 'WHERE id=:iid');
  qrTablca.Params.Items[0].AsDateTime := Now();
  qrTablca.Params.Items[1].AsInteger := 1;
  qrTablca.ExecSQL;
  qrTablca.Free;
end;

function TdevFrm.DataAktualizacjiSlownikow(): TDateTime;
var
  dtData: TDateTime;

begin
  qryDataAktualizacjiSlownikow.SQL.Clear;
  qryDataAktualizacjiSlownikow.SQL.Add('SELECT * FROM `test`');
  qryDataAktualizacjiSlownikow.Open;

  dtData := qryDataAktualizacjiSlownikowdataimp.AsDateTime;

  qryDataAktualizacjiSlownikow.Close;

  result := dtData;
end;

procedure TdevFrm.CreateTable();
begin

  if not TableExists('test') then
  begin
    CreateTableTest();
    AddPobranieSlownikow();
  end;
end;

end.
