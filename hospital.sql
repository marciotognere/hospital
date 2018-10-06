CREATE TABLE uf(
  sigla CHAR(2) NOT NULL,
  nome VARCHAR(20) NOT NULL,
  CONSTRAINT pk_uf
    PRIMARY KEY(sigla)
);

CREATE TABLE cidade(
  cod_cidade INTEGER NOT NULL,
  nome       VARCHAR(20) NOT NULL,
  uf_sigla   CHAR(2) NOT NULL,
  CONSTRAINT pk_cidade
    PRIMARY KEY(cod_cidade),
  CONSTRAINT fk_cidade_uf
    FOREIGN KEY(uf_sigla)
    REFERENCES uf(sigla)
);

CREATE TABLE medico(
  crm     INTEGER      NOT NULL,
  nome    VARCHAR(20)  NOT NULL,
  sexo    CHAR(1)      NOT NULL,
  salario NUMERIC(6,2) NOT NULL,
  CONSTRAINT pk_medico
    PRIMARY KEY(crm)
);

CREATE TABLE especialidade(
  cod_especialidade INTEGER     NOT NULL,
  nome              VARCHAR(20) NOT NULL,
  CONSTRAINT pk_especialidade
    PRIMARY KEY(cod_especialidade)
);

CREATE TABLE medico_especialidade(
  medico_crm                      INTEGER NOT NULL,
  especialidade_cod_especialidade INTEGER NOT NULL,
  CONSTRAINT pk_medico_especialidade
    PRIMARY KEY(medico_crm,especialidade_cod_especialidade),
  CONSTRAINT fk_medico_especialidade_medico
    FOREIGN KEY(medico_crm)
    REFERENCES medico(crm),
  CONSTRAINT fk_medico_especialidade_especialidade
    FOREIGN KEY(especialidade_cod_especialidade)
    REFERENCES especialidade(cod_especialidade)
);

CREATE TABLE internacao(
  paciente_cod_paciente INTEGER      NOT NULL,
  data_inicio           DATE         NOT NULL,
  data_final            DATE         NOT NULL,
  custo_internacao      NUMERIC(6,2) NOT NULL,
  obs                   VARCHAR(40)  NOT NULL,
  CONSTRAINT pk_internacao
    PRIMARY KEY(paciente_cod_paciente,data_inicio)
);

CREATE TABLE paciente(
  cod_paciente                     INTEGER     NOT NULL,
  nome                             VARCHAR(20) NOT NULL,
  data_nasc                        DATE        NOT NULL,
  sexo                             CHAR(1)     NOT NULL,
  telefone                         CHAR(10)    NOT NULL,
  limite_gastos                    INTEGER     NOT NULL,
  rua                              VARCHAR(25) NOT NULL,
  bairro                           VARCHAR(20) NOT NULL,
  cep                              CHAR(8)     NOT NULL,
  internacao_data_inicio           DATE        NOT NULL,
  internacao_paciente_cod_paciente INTEGER     NOT NULL,
  cidade_cod_cidade                INTEGER     NOT NULL,
  CONSTRAINT pk_cod_paciente
    PRIMARY KEY(cod_paciente),
  CONSTRAINT ck_sexo
    CHECK(sexo = 'F' OR sexo = 'M' OR sexo = 'O'),
  CONSTRAINT fk_paciente_internacao
    FOREIGN KEY(internacao_data_inicio,internacao_paciente_cod_paciente)
    REFERENCES internacao(data_inicio,paciente_cod_paciente),
  CONSTRAINT fk_paciente_cidade
    FOREIGN KEY(cidade_cod_cidade)
    REFERENCES cidade(cod_cidade)
);

CREATE TABLE leito(
  cod_leito   INTEGER     NOT NULL,
  localizacao VARCHAR(20) NOT NULL,
  CONSTRAINT pk_leito
    PRIMARY KEY(cod_leito)
);

CREATE TABLE itens(
  cod_itens INTEGER      NOT NULL,
  tipo      CHAR(1)      NOT NULL,
  valor     NUMERIC(6,2) NOT NULL,
  descricao VARCHAR(40)  NOT NULL,
  CONSTRAINT pk_itens
    PRIMARY KEY(cod_itens)
);

CREATE TABLE internacao_itens(
  internacao_data_inicio           DATE         NOT NULL,
  internacao_paciente_cod_paciente INTEGER      NOT NULL,
  itens_cod_itens                  INTEGER      NOT NULL,
  medico_crm                       INTEGER      NOT NULL,
  leito_cod_leito                  INTEGER      NOT NULL,
  valor                            NUMERIC(6,2) NOT NULL,
  data_internacao_itens            DATE         NOT NULL,
  CONSTRAINT pk_internacao_itens
    PRIMARY KEY(internacao_data_inicio,internacao_paciente_cod_paciente,itens_cod_itens),
  CONSTRAINT fk_internacao_itens_internacao
    FOREIGN KEY(internacao_data_inicio,internacao_paciente_cod_paciente)
    REFERENCES internacao(data_inicio,paciente_cod_paciente),
  CONSTRAINT fk_internacao_itens_itens
    FOREIGN KEY(itens_cod_itens)
    REFERENCES itens(cod_itens),
  CONSTRAINT fk_internacao_itens_medico
    FOREIGN KEY(medico_crm)
    REFERENCES medico(crm),
  CONSTRAINT fk_internacao_itens_leito
    FOREIGN KEY(leito_cod_leito)
    REFERENCES leito(cod_leito)
);