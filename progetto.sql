drop table if exists Dipendente;
drop table if exists Farmacista;
drop table if exists Magazziniere;
drop table if exists Impiegato;
drop table if exists Sede;
drop table if exists Magazzino;
drop table if exists Batch;
drop table if exists Prodotto;
drop table if exists ProdottoDeperibile;
drop table if exists Ricevuta;
drop table if exists TransazioneUscente;
drop table if exists Ricetta;
drop table if exists Fornitura;
drop table if exists Fornitore;
drop table if exists OperazioneSuMagazzino;
drop table if exists Assunzione;
drop table if exists Afferenza;
drop table if exists Direzione;
drop table if exists Contenimento;
drop table if exists Retribuzione;
drop table if exists ComposizioneRicevuta;
drop table if exists ComposizioneFornitura;
drop table if exists Prescrizione;
drop table if exists RR;
drop table if exists Ordine;
drop table if exists Vendita;
drop table if exists Ricezione;
drop table if exists Effettuazione;

/*********************************************************************************************/

/*					CREAZIONE DOMINIO					*/

/*********************************************************************************************/
drop domain if exists fascia;

create domain fascia 
as varchar[4] default 'C' 
check(value=='A' or value=='C' or value=='Cbis') /*	mancano un botto di fasce	*/

/*********************************************************************************************/

/*					ENTITA PRINCIPALI					*/

/*********************************************************************************************/

create table Dipendente{
	CF			character[16]	primary key,
	email			varchar[100]	unique	not null,
	data_nascita 		date 			not null,
	nome 			varchar[20] 		not null,
	cognome 		varchar[20] 		not null,
	sex 			varchar[1] 	check(value== 'M' or value=='F' or value=='A')	default 'A',
	citta 			varchar[20] 		not null,
	via 			varchar[50] 		not null,
	civico 		varchar[5] 		not null,
	CAP 			char[5]								default null,
	stato 			varchar[3] 		not null					default "IT",
	stipendio_mensile	numeric(9,2) 		not null					default 0,
	telefono 		varchar[13]

}engine=innodb default charset=latin1;

create table Farmacista{
	CF_farmacista 		char[16]	primary key,
	
	foreign key(CF_farmacista) references Dipendente(CF) on update cascade on delete cascade

}engine=innodb default charset=latin1;

create table Magazziniere{
	CF_magazziniere 	char[16] 	primary key,
	
	foreign key(CF_farmacista) references Dipendente(CF)		on update cascade on delete cascade

}engine=innodb default charset=latin1;

create table Impiegato{
	CF_impiegato 		char[16] 	primary key,
	is_direttore 		boolean		not null					default false,
	
	foreign key(CF_farmacista) references Dipendente(CF)		on update cascade on delete cascade

}engine=innodb default charset=latin1;

create table Sede{
	id_sede 		int 		unsigned 	auto_increment 	primary key,
	telefono 		char[13],
	citta 			varchar[20] 		not null],
	via 			varchar[20] 		not null,
	civico 		varchar[5] 		not null,
	CAP 			char[5] 		not null,
	stato 			varchar[3] 		not null 					default "IT"

}engine=innodb default charset=latin1;

create table Magazzino{
	id_magazzino 		char[5] 	primary key,
	
	foreign key(id_magazzino) references Sede(id_sede)		on update cascade on delete cascade

}engine=innodb default charset=latin1;

create table Batch{
	codice_batch 		varchar[16] 	primary key

}engine=innodb default charset=latin1;

create table Prodotto{
	codice_prodotto 	varchar[16] 	primary key,
	nome 			varchar[16] 		not null,
	marca 			varchar[20] 		not null 					default 'Laboratorio Escobar',
	prezzo unitario 	numeric(4,2) 		not null

}engine=innodb default charset=latin1;

create table ProdottoDeperibile{
	codice_prodotto 	varchar[16] 	primary key,
	data _scadenza 	date 			not null,
	p_attivo 		varchar[15],
	p_fascia 		fascia,
	r_necessaria 		varchar[5],
	
	foreign key(codice_prodotto) references Prodotto(codice_prodotto)

}engine=innodb default charset=latin1;

create table Ricevuta{
	n_ricevuta 		char[16] 	primary key,
	timestamp_r 		timestamp 		not null 					default current_timestamp

}engine=innodb default charset=latin1;

create table TransazioneUscente{
	n_transazione 		char[16] 	auto_increment 	primary key,
	timestamp_t 		timestamp 		not null 					default current_timestamp,
	importo 		numeric(9,2) 		not null 					default 0

}engine=innodb default charset=latin1;

create table Ricetta{
	n_ricetta 		char[16]  	auto_increment		primary key,
	tipo 			varchar[10] 	check() 						default "mah",
	data_scadenza 		date 									default null,
	CF_medico 		char[16]		not null,
	CF_paziente 		char[16] 		not null

}engine=innodb default charset=latin1;

create table Fornitura{
	id_fornitura 		char[16]	primary key

}engine=innodb default charset=latin1;

create table Fornitore{
	p_iva 			char[11] 	primary key,
	c_c 			char[27] 	unique 	not null,
	pec 			varchar[100] 	unique 	not null,
	telefono 		varchar[13],
	citta 			varchar[20] 			not null],
	via 			varchar[20] 			not null,
	civico 		varchar[5] 			not null,
	CAP 			char[5] 			not null,
	stato 			varchar[3] 			not null 				default "IT"

}engine=innodb default charset=latin1;

create table OpeazioneSuMagazzino{
	CF_magazziniere 	char[16] 			not null
	id_fornitura 		char[16]			not null,
	id_magazzino 		int 		unsigned,
	data_op 		date 				not null 				default default current_date, 
	
	primary key(CF_magazziniere,id_fornitura,id_magazzino),
	
	foreign key(CF_magazziniere) references Magazziniere(CF_magazziniere)	on update cascade on delete cascade,
	foreign key(id_fornitura) references Fornitura(id_fornitura)			on update cascade on delete cascade,
	foreign key(id_magazzzino) references Magazzino(id_magazzino)		on update cascade on delete cascade

}engine=innodb default charset=latin1;

/*********************************************************************************************/

/*					RELATIONSHIPS						*/

/*********************************************************************************************/

/*dipendente <-> impiegato(se direttore)*/
create table Assunzione{
	CF_dipendente 		char[16]	not null,
	CF_direttore 		char[16] 	not null,
	data_assunzione 	date 		not null 		default current_date,
	
	primary key(CF_dipendente,CF_direttore),

	foreign key(CF_dipendente) references Dipendente(CF)				on update cascade on delete cascade,
	foreign key(CF_direttore) references Impiegato(CF_impiegato)			on update cascade on delete cascade

}engine=innodb default charset=latin1;

/*dipendente <-> sede*/
create table Afferenza{
	CF_dipendente 		char[16] 	primary key,
	sede 			int 		unsigned 		primary key,
	
	primary key(CF_dipendente,sed),
	
	foreign key(CF_dipendente) references Dipendente(CF)				on update cascade on delete cascade,
	foreign key(sede) references Sede(id_sede)					on update cascade on delete cascade

}engine=innodb default charset=latin1;

/*impiegato(se direttore) <-> sede*/
create table Direzione{
	CF_direttore 		char[16] 	not null,
	sede 			int 		unsigned,
	
	primary key(CF_direttore,sede),
	
	foreign key(CF_direttore) references Impiegato(CF_impiegato)			on update cascade on delete cascade,
	foreign key(sede) references Sede(id_sede)					on update cascade on delete cascade
		
}engine=innodb default charset=latin1;

/*Batch <-> Prodotto*/
create table Contenimento{
	id_batch 		varchar[16],
	codice_prodotto 	varchar[16]
	
	primary key(id_batch,codice_prodotto),
	
	foreign key(id_batch) references Batch(codice_batch)				on update cascade on delete cascade,
	foreign key(codice_prodotto) references Prodotto(codice_prodotto)		on update cascade on delete cascade

}engine=innodb default charset=latin1;

/*dipendente <-> TransazioneUscente*/
create table Retribuzione{
	CF_dipendente 		char[16],
	n_transazione 		char[16],
	
	primary key(CF_dipendente,n_transazione),
	
	foreign key(CF_dipendente) references Dipendente(CF)				on update cascade on delete cascade,
	foreign key(n_transazione) references TransazioneUscente(n_transazione)	on update cascade on delete cascade

}engine=innodb default charset=latin1;

/*dipendente <-> ricevuta*/
create table Vendita{
	n_ricevuta 		char[16],
	CF_farmacista 		char[16],
	
	primary key(n_ricevuta,CF_farmacista),
	
	foreign key(CF_farmacista) references Farmacista(CF_farmacista)		on update cascade on delete cascade,
	foreign key(n_ricevuta) references Ricevuta(n_ricevuta)			on update cascade on delete cascade

}engine=innodb default charset=latin1;

/*Fornitura <-> Batch*/
create table ComposizioneFornitura{
	id_fornitura 		char[16],
	id_batch 		varchar[16],
	
	primary key(id_fornitura,id_batch),
	
	foreign key(id_fornitura) references Fornitura(id_fornitura)			on update cascade on delete cascade,
	foreign key(id_batch) references Batch(codice_batch)				on update cascade on delete cascade

}engine=innodb default charset=latin1;

/*ProdottoDeperibile <-> Ricetta*/
create  table Prescrizione{
	codice_prodotto 	varchar[16],
	n_ricetta 		char[16],
	quantita 		numeric(2)  	not null 		default 1,
	
	primary key(codice_prodotto,n_ricetta),
	
	foreign key(codice_prodotto) references Prodotto Deperibile(codice_prodotto)	on update cascade on delete cascade,
	foreign key(n_ricetta) references Ricetta(n_ricetta)				on update cascade on delete cascade

}engine=innodb default charset=latin1;

/*Ricevuta <-> Ricetta*/
create table RR{
	n_ricetta 		char[16],
	n_ricevuta 		char[16],
	
	primary key(n_ricetta,n_ricevuta),
	
	foreign key(n_ricevuta) references Ricevuta(n_ricevuta)			on update cascade on delete cascade,
	foreign key(n_ricetta) references Ricetta(n_ricetta)				on update cascade on delete cascade

}engine=innodb default charset=latin1;

/*Fornitura <-> TransazioneUscente*/
create table Ordine{
	id_fornitura		char[16],
	n_transazione 		char[16],
	
	primary key(id_fornitura,n_transazione),
	
	foreign key(n_transazione) references TransazioneUscente(n_transazione)	on update cascade on delete restrict,    /*mantenimento storico pagamenti*/
	foreign key(id_fornitura) references Fornitura(id_fornitura)			on update cascade on delete restrict

}engine=innodb default charset=latin1;

/*Fornitore<-> Fornitura*/
create table Rifornimento{
	id_fornitura 		char[16],
	p_iva 			char[11],
	
	primary key(id_fornitura,p_iva),
	
	foreign key(id_fornitura) references Fornitura(id_fornitura)			on update cascade on delete cascade,
	foreign key(p_iva) references Fornitore(p_iva)				on update cascade on delete cascade

}engine=innodb default charset=latin1;

/*impiegato(se direttore) <-> TransazioneUscente*/
create table Autorizzazione{
	n_transazione 		char[16],
	CF_direttore 		char[16],
	
	primary key(n_transazione,CF_direttore),
	
	foreign key(n_transazione) references TransazioneUscente(n_transazione)	on update cascade on delete cascade,
	foreign key(CF_direttore) references Impiegato(CF_impiegato)			on update cascade on delete cascade

}engine=innodb default charset=latin1;

/*Batch <-> sede*/
create table Appartenenza{
	id_batch 		varchar[16],
	sede 			int 		unsigned,
	
	primary key(id_batch,sede),
	
	foreign key(id_batch) references Batch(codice_batch)				on update cascade on delete cascade,
	foreign key(sede) references Sede(id_sede)					on update cascade on delete cascade

}engine=innodb default charset=latin1;

/*Ricevuta <-> Prodotto*/
create table ComposizioneRicevuta{
	codice_prodotto 	varchar[16],
	n_ricevuta 		char[16],
	
	primary key(codice_prodotto,n_ricevuta),
	
	foreign key(codice_prodotto) references Prodotto(codice_prodotto)		on update cascade on delete restrict,   /*mantenimento storico ricevute*/
	foreign key(n_ricevuta) references Ricevuta(n_ricevuta)			on update cascade on delete restrict

}engine=innodb default charset=latin1;

/*Ricevuta <-> sede*/
create table Ricezione{
	n_ricevuta 		char[16],
	sede 			int 		unsigned,
	
	primary key(n_ricevuta,sede),
	
	foreign key(sede) references Sede(id_sede)					on update cascade on delete restrict,    /*mantenimento storico ricevute*/
	foreign key(n_ricevuta) references Ricevuta(n_ricevuta)			on update cascade on delete restrict

}engine=innodb default charset=latin1;

/*TransazioneUscente <-> sede*/
create table Effettuazione{
	n_transazione 		char[16],
	sede 			int 		unsigned,
	
	primary key(sede,_n_transazione),
	
	foreign key(sede) references Sede(id_sede)					on update cascade on delete restrict,    /*mantenimento storico pagamenti*/
	foreign key(n_transazione) references TransazioneUscente(n_transazione)	on update cascade on delete restrict

}engine=innodb default charset=latin1;

/*********************************************************************************************/

/*					INSERIMENTO VALORI					*/

/*********************************************************************************************/


insert into Dipendente(CF,email,data_nascita,nome,cognome,sex,citta,via,civico,CAP,stato,stipendio_mensile,telefono) values
('ZNZDZN42S10E071F','costanzino@gmail.com',		01-01-1990,'costanzo','vecchio','M',		'Padova','Roma','2B','35020','IT',		2000,	'+398887760093'),/*farmacista pd*/
('ZTPCNY52H51E639P','franceschella@gmail.com',	5-060-2022,'francesca','petrella','F',	'Albignasego','Guizza','441','35021','IT',	1700,	'+3935126265555'),/*magazziniere pd*/
('HNTHRZ65S62E048Z','paolo.rosso@gmail.com',		17-11-1977,'paolo','rossi','M',		'Roma','verdi','4','10452','IT',		2500,	'+391234567895'),/*farmacista ro*/
('CXFCRD88P59B285H','massimo.pericolo@gmail.com',	23-10-1995,'massimo','pericolo','M',		'Milano', 'navigli','1A','96857','IT',	2000,	'+399876543211'),/*impiegato mi*/
('FCTNBT60A66E625C','mammamia@gmail.com','maria',	09-02-2000,'madre','addolorata','F',		'Bari','S.Antono'.'44','52526','IT',		4500,	'+3977778888621'),/*direttore ba*/
('LKNHDD37T45C082I','gianfrancioschio@gmail.com',	02-02-1982,'gian','francioschio','A',		'Roma','dei martiri','9','IT','10452',	5000,	null),		 /*direttore ro*/
('YZCLHH46D26E182P','prigioniero@libero.it',		05-12-1988,'giulia','jail','F',		'Milano','napoleone','8bis','96857','IT',	2000,	'+395665897432'),/*direttore mi*/
('GYNQKD39A26A745S','fredda.laura@hotmail.com',	08-09-2001,'laura','fredda','F',		'Lugano','wurstel','71',null,'SW',		1700,	'+405698327416'),/*farmacista mi*/
('TSWWHP49M70I661Z','aiuto.chenoia@gmail.com',	08-04-2003,'aiuto','chenoia','M',		'Bari','cannolo','7','52526','IT',		1700,	'+398527416543'),/*magazziniere ba*/
('CHBBQT80R45A266E','alessandrino99@libero.it',	25-12-1999,'alessandro','magno','M',		'Roma','caduti','101','10452','IT',		1500,	'+396664875139'),/*magazziniere ro*/
('CDCRHT98E56F058Y','franca.paolini@hotmail.com',	18-01-1984,'franca','petrella','F',		'Cagliari','mirto','6T','55555','IT',		5000,	'+399832741965'),/*direttore ca*/
('HBBGFR61H17A692E','bassi.maestro@gmail.com',	13-06-1990,'davide','bassi','M',		'Pecorinia','pecora','20','IT','55554',	1600,	'+393298765419'),/*farmacista ca*/
('MTCMTT98R16G224G','matteoumatche@gmail.com',	06-10-1998,'Matteo','Umatche','M',		'Cartura','A.Vivaldi','5','35025','IT',	5000,	'+393888766242'),/*direttore pd*/
('WTZZBV34M01F176K','popefrancis@church.com',		01-01-1950,'francesco ','bergoglio','A',	'citta del vaticano','piazza san pietro','0',null,'VC',1500,'+390000000000'),/*magazziniere ro*/
('BFNZSR60B45D819Z','spiderman@marvel.com',		31-01-1973,'peter','parker','M',		'new cartura','ragno','15',35022,'IT',	2500,	'+395555588862'),/*farmacista*/
('JLHDFB72S49G025O','lovwpljchow@gmail.com',		09-02-1986,'caso','random','F',		'uihyf','qwert','678','95421','IT',		0036,	'+393333333332'),/*impiegato ca*/
('CCMQMK30S15L890M','giangi.pongi@hotmail.com',	19-11-2000,'gianluca','pongi','M',		'arancinia','fritta','4',52522,'IT',		2200,	'+398787564123'),/*farmacista ca*/
('QZLCDH52P11A494T','marioi.rossi@libero.it',		22-12-1991,'mario','rossi','M',		'mirtopoli','bicchiere','1','55549','IT'	1500,	'+391245789633');/*magazziniere ca*/

insert into Farmacista(CF_farmacista) values
('ZNZDZN42S10E071F'),
('HNTHRZ65S62E048Z'),
('GYNQKD39A26A745S'),
('HBBGFR61H17A692E'),
('BFNZSR60B45D819Z'),
('CCMQMK30S15L890M');

insert into Magazziniere(CF_magazziniere) values
('ZTPCNY52H51E639P'),
('TSWWHP49M70I661Z'),
('WTZZBV34M01F176K'),
('CHBBQT80R45A266E'),
('QZLCDH52P11A494T');

insert into Impiegato(CF_Impiegato,is_direttore) values
('LKNHDD37T45C082I','1'),
('CXFCRD88P59B285H','0'),
('FCTNBT60A66E625C','1'),
('MTCMTT98R16G224G','1'),
('JLHDFB72S49G025O','0');

insert into Sede(citta,via,civico,CAP,stato,telefono) values
('Padova','piazza delle erbe','1','35020','IT','0499555880'),
('Roma','colosseo','50','10452','IT','049555506'),
('Cagliari','lungomare','14','55555','IT','0499555990'),
('Bari','piazza arancino','7','52526','IT','0499555762');

insert into Magazzino(id_magazzino) values
(1),		/*Padova*/
(2),		/*Roma*/
(3),		/*Cagliari*/
(4);		/*Bari*/

insert into Batch(codice_batch) values
('0000000000000000'),('1616161616161616'),
('0101010101010101'),('8888888888888888'),
('1010101010101010'),('6666666666666666'),
('6565656565656565'),('94gh9i4uh5guh4ih'),
('5125125125125125'),('8927gyhikhbi2hic'),
('8963254715256398'),('h986rfouio7t5i79'),
('1111111111111111'),('897t8gi87yg8u789'),


insert into Prodotto(codice_prodotto,nome,marca,prezzo_unitario) values

insert into ProdottoDeperibile(codice_prodotto,data_scadenza,p_attivo,p_fascia,r_necessaria) values

insert into Ricevuta(timestamp_r) values

insert into TransazioneUscente(timestamp_t,importo) values

insert into Fornitura(id_fornitura) values

insert into Fornitore(p_iva,c_c,pec,citta,via,civico,CAP,stato,telefono) values

insert into OpreazioneSuMagazzino(CF_magazzino,id_fornitura,id_magazzino) values


/*********************************************************************************************/

/*					CREAZIONE INDICI					*/

/*********************************************************************************************/



/*********************************************************************************************/

/*					     QUERY						*/

/*********************************************************************************************/



/*********************************************************************************************/

/*					   TRIGGER						*/

/*********************************************************************************************/










