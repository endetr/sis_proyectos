CREATE OR REPLACE FUNCTION pro.f_fun_inicio_proyecto_wf (
  p_id_proyecto integer,
  p_id_usuario integer,
  p_id_usuario_ai integer,
  p_usuario_ai varchar,
  p_id_estado_wf integer,
  p_id_proceso_wf integer,
  p_codigo_estado varchar,
  p_id_depto_lb integer = NULL::integer,
  p_id_cuenta_bancaria integer = NULL::integer,
  p_estado_anterior varchar = 'no'::character varying
)
RETURNS boolean AS
$body$
/**************************************************************************
 SISTEMA:       Sistema de Cuenta Documentada
 FUNCION:       pro.f_fun_inicio_proyecto_wf
                
 DESCRIPCION:   Actualiza los estados despues del registro de estado 
 AUTOR:         
 FECHA:         
 COMENTARIOS: 

 ***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:   
 AUTOR:         
 FECHA:         
***************************************************************************/
DECLARE

    v_nombre_funcion                text;
    v_resp                          varchar;     
    v_mensaje                       varchar;    
    v_registros                     record;
    v_rec                           record;
    v_monto_ejecutar_mo             numeric;
    v_id_uo                         integer;
    v_id_usuario_excepcion          integer;
    v_resp_doc                      boolean;
    v_sincronizar                   varchar;
    v_nombre_conexion               varchar;
    v_id_int_comprobante            integer;
    v_total_det_mb					numeric;
    
     v_tipo_cobro 					varchar;
	v_bandera						varchar; 
BEGIN
    
    --Identificación del nombre de la función
    v_nombre_funcion = 'pro.f_fun_inicio_proyecto_wf';

	--raise exception 'entra';
    
    --raise exception 'id %',p_id_proceso_wf;
    --raise exception ' %',p_codigo_estado;
    --raise exception 'p_id_estado_wf %',p_id_estado_wf;
    --raise exception 'p_id_invitacion %',p_id_invitacion;
    --raise exception ' p_id_usuario%',p_id_usuario;
    ----------------------------------------------
    --Obtención de datos de la cuenta documentada
    ----------------------------------------------
    select 
        c.id_proyecto,
        c.estado,
        c.id_estado_wf,
        ew.id_funcionario
        into v_rec
    from pro.tproyecto c
    inner join wf.testado_wf ew on ew.id_estado_wf =  c.id_estado_wf
    where c.id_proyecto = p_id_proyecto;
    
   
    
      
    --Actualización del estado de la solicitud
    update pro.tproyecto set 
    id_estado_wf    = p_id_estado_wf,
    estado          = p_codigo_estado,
    id_usuario_mod  = p_id_usuario,
    id_usuario_ai   = p_id_usuario_ai,
    usuario_ai      = p_usuario_ai,
    fecha_mod       = now()                     
    where id_proyecto = p_id_proyecto;

 

    
  
 
    --Respuesta
    return true;

EXCEPTION
                    
    WHEN OTHERS THEN

        v_resp = '';
        v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
        v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
        v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
        raise exception '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;
