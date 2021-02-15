unit md_menu;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, Vcl.Controls, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWCompLabel, IWHTMLControls;

type
  TF_menu = class(TIWAppForm)
    template_menu: TIWTemplateProcessorHTML;
    link_usuario: TIWLink;
    link_sair: TIWLink;
    m_sair: TIWLink;
    Label_1: TIWLabel;
    m_usuarios: TIWLink;
    m_produtos: TIWLink;
    m_principal: TIWLink;
    m_fornecedores: TIWLink;
    m_financeiro: TIWLink;
    m_vendas: TIWLink;

    procedure IWAppFormShow(Sender: TObject);
    procedure link_usuarioClick(Sender: TObject);
    procedure link_sairClick(Sender: TObject);
    procedure m_usuariosClick(Sender: TObject);
    procedure m_produtosClick(Sender: TObject);
    procedure m_fornecedoresClick(Sender: TObject);
    procedure m_vendasClick(Sender: TObject);
    procedure m_lancamentosClick(Sender: TObject);

  public

  end;

implementation

{$R *.dfm}

uses
  ServerController, UserSessionUnit,
  md_login, md_usuarios, md_fornecedores, md_produtos, md_vendas, md_lancamentos;

procedure TF_menu.IWAppFormShow(Sender: TObject);
begin
  Label_1.Caption := USRNAME;
end;

procedure TF_menu.link_usuarioClick(Sender: TObject);
begin
  TF_usuarios.Create(WebApplication).Show;
end;

procedure TF_menu.m_usuariosClick(Sender: TObject);
begin
  TF_usuarios.Create(WebApplication).Show;
end;

procedure TF_menu.m_fornecedoresClick(Sender: TObject);
begin
  TF_fornecedores.Create(WebApplication).Show;
end;

procedure TF_menu.m_lancamentosClick(Sender: TObject);
begin
  TF_lancamentos.Create(WebApplication).Show;
end;

procedure TF_menu.m_produtosClick(Sender: TObject);
begin
  TF_produtos.Create(WebApplication).Show;
end;

procedure TF_menu.m_vendasClick(Sender: TObject);
begin
  TF_vendas.Create(WebApplication).Show;
end;

procedure TF_menu.link_sairClick(Sender: TObject);
begin
  TF_login.Create(WebApplication).Show;
end;

end.
