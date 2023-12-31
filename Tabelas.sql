CREATE TABLE CLIENTE( 
    CPF_CLI CHAR(11) PRIMARY KEY CHECK(LENGTH(CPF_CLI) = 11), 
    NOME VARCHAR(30) NOT NULL, 
    ENDERECO VARCHAR(80) NOT NULL, 
    TELEFONE CHAR(13) NOT NULL CHECK(LENGTH(TELEFONE) = 13 AND TELEFONE NOT LIKE '(__)%')
);

CREATE TABLE CARTAO( 
    NUM_CARTAO CHAR(16) PRIMARY KEY CHECK(LENGTH(NUM_CARTAO) = 16), 
    VALIDADE DATE NOT NULL, 
    TIPO CHAR(1) NOT NULL CHECK(TIPO = 'D' OR TIPO = 'C'), 
    COD_SEG CHAR(3) NOT NULL CHECK(LENGTH(COD_SEG) = 3), 
    CPF_CLI NOT NULL REFERENCES CLIENTE(CPF_CLI) ON DELETE CASCADE
);

CREATE TABLE AGENCIA(
    NUM_AG NUMBER GENERATED AS IDENTITY
    		START WITH 0001 INCREMENT BY 1
    		PRIMARY KEY,
    ENDERECO VARCHAR(80) NOT NULL UNIQUE,
    NOME VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE DEPARTAMENTO(
    COD_DPT CHAR(5) PRIMARY KEY CHECK(LENGTH(COD_DPT) = 5),
    NOME VARCHAR(20) NOT NULL
);

CREATE TABLE FUNCIONARIO(
    MATRICULA NUMBER GENERATED AS IDENTITY
    			START WITH 1000 INCREMENT BY 10
    			PRIMARY KEY,
    CARGO VARCHAR(20) DEFAULT('DESALOCADO') NOT NULL,
    NOME VARCHAR(30) NOT NULL,
    DATA_ADMISSAO DATE NOT NULL,
    NUM_AG REFERENCES AGENCIA(NUM_AG) ON DELETE SET NULL,
    COD_DPT REFERENCES DEPARTAMENTO(COD_DPT) ON DELETE SET NULL
);

CREATE TABLE CONTA(
    NUM_CONTA NUMBER GENERATED AS IDENTITY
    			START WITH 100000 INCREMENT BY 1
    			PRIMARY KEY,
    SALDO NUMBER(8,2) NOT NULL,
    TIPO_CONTA CHAR(1) NOT NULL CHECK(TIPO_CONTA = 'C' OR TIPO_CONTA = 'P'),
    DATA_ABERTURA DATE NOT NULL,
    CPF_CLI NOT NULL REFERENCES CLIENTE(CPF_CLI) ON DELETE CASCADE,
    NUM_AG REFERENCES AGENCIA(NUM_AG)
    			ON DELETE SET NULL
);

CREATE TABLE TRANSACAO(
    ID_TRANS NUMBER GENERATED AS IDENTITY
    			START WITH 100000 INCREMENT BY 1
    			PRIMARY KEY,
    VALOR NUMBER(8,2) NOT NULL,
    PERCENT_UNIT NUMBER(8,2) NOT NULL,
    TIPO CHAR(1) NOT NULL CHECK(TIPO = 'S' OR TIPO = 'D' OR TIPO = 'T'),
    DATA_TRANS TIMESTAMP NOT NULL,
    NUM_CONTA NOT NULL REFERENCES CONTA(NUM_CONTA)
);

CREATE TRIGGER calcular_percent_unit
    BEFORE INSERT OR UPDATE ON TRANSACAO
    FOR EACH ROW
    BEGIN
    	:NEW.PERCENT_UNIT := :NEW.VALOR * 0.05;
	END;
/
