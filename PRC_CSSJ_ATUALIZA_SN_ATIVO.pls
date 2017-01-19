create or replace PROCEDURE       PRC_CSSJ_ATUALIZA_SN_ATIVO(VOPCAO IN VARCHAR2) IS
  
  ------------------------------------------------------------------------------------------------
  -- PROPOSITO:
  -- Bloquear todos os usu�rios de sistema para atualiza��o.
  -- Cria uma tabela tempor�ria com todos usu�rios ativos no momento do bloqueio e realiza o
  -- bloqueio.
  -- Modo de utiliza��o: EXEC DBAMV.PRC_CSSJ_ATUALIZA_SN_ATIVO(<opera��o>);
  -- Tipos de OPERA��O: 'S' para Ativar ou 'N' para bloquear.
  --
  -- HIST�RICO DE MODIFICA��O:
  -- DATA        AUTOR    DESCRI��O
  -- ----------  -------  ------------------------------------------------------------------------
  -- 28/12/2016  ROBERTO  Idealiza��o e cria��o da procedure.
  ------------------------------------------------------------------------------------------------
  
  COMANDO VARCHAR2(200);
  
BEGIN

  IF VOPCAO = 'N' THEN
    COMANDO := 'CREATE TABLE DBAMV.CSSJ_USUARIOS_DBASGU AS (SELECT CD_USUARIO FROM DBASGU.USUARIOS WHERE SN_ATIVO = ''S'' AND CD_USUARIO NOT IN (''DBAMV'',''DBASGU'',''MVINTEGRA'',''DBAPS'',''USERMV''))';
    EXECUTE IMMEDIATE COMANDO;
    UPDATE DBASGU.USUARIOS SET SN_ATIVO = 'N' WHERE CD_USUARIO IN (SELECT CD_USUARIO FROM DBAMV.CSSJ_USUARIOS_DBASGU);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(COMANDO);
  ELSE
    IF VOPCAO = 'S' THEN
      UPDATE DBASGU.USUARIOS SET SN_ATIVO = 'S' WHERE CD_USUARIO IN (SELECT CD_USUARIO FROM DBAMV.CSSJ_USUARIOS_DBASGU);
      COMANDO := 'DROP TABLE DBAMV.CSSJ_USUARIOS_DBASGU';
      EXECUTE IMMEDIATE COMANDO;
      COMMIT;
      DBMS_OUTPUT.PUT_LINE(COMANDO);
    ELSE
      DBMS_OUTPUT.PUT_LINE('OPERA��O N�O ENCONTRADA. ESCOLHA: <S> PARA DES-BLOQUEAR OU <N> PARA BLOQUEAR');
    END IF;
  END IF;
END PRC_CSSJ_ATUALIZA_SN_ATIVO;