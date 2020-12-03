//Copyright 2020 Andrey S. Ionisyan (anserion@gmail.com)
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    BTN_ROM_read: TButton;
    BTN_sum1: TButton;
    BTN_sum2: TButton;
    BTN_sum3: TButton;
    BTN_P_set: TButton;
    BTN_X_set: TButton;
    BTN_quick: TButton;
    Edit_res: TEdit;
    Label1: TLabel;
    Label_P: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    SG_P_X: TStringGrid;
    SG_sum1: TStringGrid;
    SG_sum2: TStringGrid;
    SG_sum3: TStringGrid;
    SG_sum0: TStringGrid;
    SG_ROM: TStringGrid;
    procedure BTN_P_setClick(Sender: TObject);
    procedure BTN_quickClick(Sender: TObject);
    procedure BTN_ROM_readClick(Sender: TObject);
    procedure BTN_sum1Click(Sender: TObject);
    procedure BTN_sum2Click(Sender: TObject);
    procedure BTN_sum3Click(Sender: TObject);
    procedure BTN_X_setClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure BTN_ROM_calc;
  public

  end;

const max_p=255;

var
  Form1: TForm1;

  PP:LongInt;
  P,X: array[1..8]of integer;
  ROM:array[1..8,0..max_p]of integer;
  sum0:array[1..8]of integer;
  sum1,corr1:array[1..4]of integer;
  sum2,corr2:array[1..2]of integer;
  sum3,corr3:integer;
  res_dec:integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.BTN_ROM_calc;
var i,k,max_p,tmp_pp,basis:integer;
begin
  for k:=1 to 8 do SG_ROM.Cells[k,0]:='p'+IntToStr(k)+'='+IntToStr(P[k]);

  max_p:=P[1];
  for k:=1 to 8 do
    if max_p<P[k] then max_p:=P[k];

  SG_ROM.RowCount:=max_p+1;
  for i:=0 to max_p-1 do SG_ROM.Cells[0,i+1]:=IntToStr(i);
  for k:=1 to 8 do
    for i:=0 to max_p-1 do SG_ROM.Cells[k,i+1]:='';

  for k:=1 to 8 do
  begin
    ROM[k,0]:=0;
    tmp_pp:=1; basis:=0;
    for i:=1 to 8 do if i<>k then tmp_pp:=tmp_pp*P[i];
    for i:=1 to P[k]-1 do if ((tmp_pp*i) mod P[k])=1 then basis:=tmp_pp*i;
    for i:=1 to P[k]-1 do ROM[k,i]:=(basis*i) mod PP;
  end;

  for k:=1 to 8 do
    for i:=0 to P[k]-1 do
      SG_ROM.Cells[k,i+1]:=IntToStr(ROM[k,i]);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SG_P_X.Cells[0,0]:='основания';
  SG_P_X.Cells[1,0]:='2';
  SG_P_X.Cells[2,0]:='3';
  SG_P_X.Cells[3,0]:='5';
  SG_P_X.Cells[4,0]:='7';
  SG_P_X.Cells[5,0]:='11';
  SG_P_X.Cells[6,0]:='13';
  SG_P_X.Cells[7,0]:='17';
  SG_P_X.Cells[8,0]:='19';

  SG_P_X.Cells[0,1]:='Число в СОК';
  SG_P_X.Cells[1,1]:='0';
  SG_P_X.Cells[2,1]:='0';
  SG_P_X.Cells[3,1]:='0';
  SG_P_X.Cells[4,1]:='0';
  SG_P_X.Cells[5,1]:='0';
  SG_P_X.Cells[6,1]:='0';
  SG_P_X.Cells[7,1]:='0';
  SG_P_X.Cells[8,1]:='0';

  SG_ROM.Cells[0,0]:='цифра';

  SG_sum0.Cells[0,0]:='извлечено';

  SG_sum1.Cells[0,0]:='сумма';
  SG_sum1.Cells[0,1]:='коррекция';

  SG_sum2.Cells[0,0]:='сумма';
  SG_sum2.Cells[0,1]:='коррекция';

  SG_sum3.Cells[0,0]:='сумма';
  SG_sum3.Cells[0,1]:='коррекция';

  BTN_quickClick(self);
end;

procedure TForm1.BTN_quickClick(Sender: TObject);
begin
  BTN_P_setClick(self);
  BTN_X_setClick(self);
  BTN_ROM_calc;
  BTN_ROM_readClick(self);
  BTN_sum1Click(self);
  BTN_sum2Click(self);
  BTN_sum3Click(self);
end;

procedure TForm1.BTN_P_setClick(Sender: TObject);
var k,tmp:integer;
begin
  for k:=1 to 8 do if not(TryStrToInt(SG_P_X.Cells[k,0],tmp)) then SG_P_X.Cells[k,0]:='1';
  for k:=1 to 8 do P[k]:=StrToInt(SG_P_X.Cells[k,0]);
  PP:=1; for k:=1 to 8 do PP:=PP*P[k];
  BTN_ROM_calc;

  Label_P.caption:='Диапазон СОК: '+IntToStr(PP);
  for k:=1 to 8 do SG_P_X.Cells[k,0]:=IntToStr(P[k]);
end;

procedure TForm1.BTN_X_setClick(Sender: TObject);
var k,tmp:integer;
begin
  for k:=1 to 8 do if not(TryStrToInt(SG_P_X.Cells[k,1],tmp)) then SG_P_X.Cells[k,1]:='0';
  for k:=1 to 8 do X[k]:=StrToInt(SG_P_X.Cells[k,1]);
  for k:=1 to 8 do if X[k]>=P[k] then X[k]:=P[k]-1;
  for k:=1 to 8 do if X[k]<0 then X[k]:=0;
  for k:=1 to 8 do SG_P_X.Cells[k,1]:=IntToStr(X[k]);
end;

procedure TForm1.BTN_ROM_readClick(Sender: TObject);
var k:integer;
begin
  for k:=1 to 8 do sum0[k]:=ROM[k,X[k]];
  for k:=1 to 8 do SG_sum0.Cells[k,0]:=IntToStr(sum0[k]);
end;

procedure TForm1.BTN_sum1Click(Sender: TObject);
var k:integer;
begin
  sum1[1]:=sum0[1]+sum0[2]; if sum1[1]<PP then corr1[1]:=sum1[1] else corr1[1]:=sum1[1]-pp;
  sum1[2]:=sum0[3]+sum0[4]; if sum1[2]<PP then corr1[2]:=sum1[2] else corr1[2]:=sum1[2]-pp;
  sum1[3]:=sum0[5]+sum0[6]; if sum1[3]<PP then corr1[3]:=sum1[3] else corr1[3]:=sum1[3]-pp;
  sum1[4]:=sum0[7]+sum0[8]; if sum1[4]<PP then corr1[4]:=sum1[4] else corr1[4]:=sum1[4]-pp;
  for k:=1 to 4 do SG_sum1.Cells[k,0]:=IntToStr(sum1[k]);
  for k:=1 to 4 do SG_sum1.Cells[k,1]:=IntToStr(corr1[k]);
end;

procedure TForm1.BTN_sum2Click(Sender: TObject);
var k:integer;
begin
  sum2[1]:=corr1[1]+corr1[2]; if sum2[1]<PP then corr2[1]:=sum2[1] else corr2[1]:=sum2[1]-pp;
  sum2[2]:=corr1[3]+corr1[4]; if sum2[2]<PP then corr2[2]:=sum2[2] else corr2[2]:=sum2[2]-pp;
  for k:=1 to 2 do SG_sum2.Cells[k,0]:=IntToStr(sum2[k]);
  for k:=1 to 2 do SG_sum2.Cells[k,1]:=IntToStr(corr2[k]);
end;

procedure TForm1.BTN_sum3Click(Sender: TObject);
begin
  sum3:=corr2[1]+corr2[2]; if sum3<PP then corr3:=sum3 else corr3:=sum3-pp;
  SG_sum3.Cells[1,0]:=IntToStr(sum3);
  SG_sum3.Cells[1,1]:=IntToStr(corr3);
  res_dec:=corr3;
  Edit_res.text:=IntToStr(res_dec);
end;

end.

