CREATE OR REPLACE FUNCTION pro.ft_componente_macro_ime (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:        Sistema de Proyectos
 FUNCION:         pro.ft_componente_macro_ime
 DESCRIPCION:   Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tcomponente_macro'
 AUTOR:          (admin)
 FECHA:            22-07-2019 14:47:14
 COMENTARIOS:    
***************************************************************************
 HISTORIAL DE MODIFICACIONES:
#ISSUE                FECHA                AUTOR                DESCRIPCION
 #17                22-07-2019 14:47:14 EGS                 Funcion que gestiona las operaciones basicas (inserciones, modificaciones, eliminaciones de la tabla 'pro.tcomponente_macro'    
 #
 ***************************************************************************/

DECLARE

    v_nro_requerimiento        integer;
    v_parametros               record;
    v_id_requerimiento         integer;
    v_resp                    varchar;
    v_nombre_funcion        text;
    v_mensaje_error         text;
    v_id_componente_macro    integer;
                
BEGIN

    v_nombre_funcion = 'pro.ft_componente_macro_ime';
    v_parametros = pxp.f_get_record(p_tabla);

    /*********************************    
     #TRANSACCION:  'PRO_COMPM_INS'
     #DESCRIPCION:    Insercion de registros
     #AUTOR:        admin    
     #FECHA:        22-07-2019 14:47:14
    ***********************************/

    if(p_transaccion='PRO_COMPM_INS')then
                    
        begin
            --Sentencia de la insercion
            insert into pro.tcomponente_macro(
            estado_reg,
            nombre,
            descripcion,
            id_proyecto,
            id_usuario_reg,
            fecha_reg,
            id_usuario_ai,
            usuario_ai,
            id_usuario_mod,
            fecha_mod
              ) values(
            'activo',
            v_parametros.nombre,
            v_parametros.descripcion,
            v_parametros.id_proyecto,
            p_id_usuario,
            now(),
            v_parametros._id_usuario_ai,
            v_parametros._nombre_usuario_ai,
            null,
            null
                            
            
            
            )RETURNING id_componente_macro into v_id_componente_macro;
            
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Componente Macro almacenado(a) con exito (id_componente_macro'||v_id_componente_macro||')'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_componente_macro',v_id_componente_macro::varchar);

            --Devuelve la respuesta
            return v_resp;

        end;

    /*********************************    
     #TRANSACCION:  'PRO_COMPM_MOD'
     #DESCRIPCION:    Modificacion de registros
     #AUTOR:        admin    
     #FECHA:        22-07-2019 14:47:14
    ***********************************/

    elsif(p_transaccion='PRO_COMPM_MOD')then

        begin
            --Sentencia de la modificacion
            update pro.tcomponente_macro set
            nombre = v_parametros.nombre,
            descripcion = v_parametros.descripcion,
            id_proyecto = v_parametros.id_proyecto,
            id_usuario_mod = p_id_usuario,
            fecha_mod = now(),
            id_usuario_ai = v_parametros._id_usuario_ai,
            usuario_ai = v_parametros._nombre_usuario_ai
            where id_componente_macro=v_parametros.id_componente_macro;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Componente Macro modificado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_componente_macro',v_parametros.id_componente_macro::varchar);
               
            --Devuelve la respuesta
            return v_resp;
            
        end;

    /*********************************    
     #TRANSACCION:  'PRO_COMPM_ELI'
     #DESCRIPCION:    Eliminacion de registros
     #AUTOR:        admin    
     #FECHA:        22-07-2019 14:47:14
    ***********************************/

    elsif(p_transaccion='PRO_COMPM_ELI')then

        begin
            --Sentencia de la eliminacion
            delete from pro.tcomponente_macro
            where id_componente_macro=v_parametros.id_componente_macro;
               
            --Definicion de la respuesta
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje','Componente Macro eliminado(a)'); 
            v_resp = pxp.f_agrega_clave(v_resp,'id_componente_macro',v_parametros.id_componente_macro::varchar);
              
            --Devuelve la respuesta
            return v_resp;

        end;
         
    else
     
        raise exception 'Transaccion inexistente: %',p_transaccion;

    end if;

EXCEPTION
                
    WHEN OTHERS THEN
        v_resp='';
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