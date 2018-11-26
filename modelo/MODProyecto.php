<?php
/**
*@package pXP
*@file gen-MODProyecto.php
*@author  (admin)
*@date 28-09-2017 20:12:15
*@description Clase que envia los parametros requeridos a la Base de datos para la ejecucion de las funciones, y que recibe la respuesta del resultado de la ejecucion de las mismas
*/

class MODProyecto extends MODbase{

	function __construct(CTParametro $pParam){
		parent::__construct($pParam);
	}

	function listarProyecto(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_proyecto_sel';
		$this->transaccion='PRO_PROY_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion

		//Definicion de la lista del resultado del query
		$this->captura('id_proyecto','int4');
		$this->captura('codigo','varchar');
		$this->captura('nombre','varchar');
		$this->captura('fecha_ini','date');
		$this->captura('fecha_fin','date');
		$this->captura('id_tipo_cc','int4');
		$this->captura('estado_reg','varchar');
		$this->captura('usuario_ai','varchar');
		$this->captura('fecha_reg','timestamp');
		$this->captura('id_usuario_reg','int4');
		$this->captura('id_usuario_ai','int4');
		$this->captura('id_usuario_mod','int4');
		$this->captura('fecha_mod','timestamp');
		$this->captura('usr_reg','varchar');
		$this->captura('usr_mod','varchar');
		$this->captura('codigo_tcc','varchar');
		$this->captura('nombre_tcc','varchar');
		$this->captura('id_moneda','int4');
		$this->captura('desc_moneda','varchar');
		$this->captura('id_depto_conta','int4');
		$this->captura('desc_depto','varchar');
		$this->captura('id_int_comprobante_1','int4');
		$this->captura('id_int_comprobante_2','int4');
		$this->captura('id_int_comprobante_3','int4');
		$this->captura('id_proceso_wf_cierre','integer');
		$this->captura('id_estado_wf_cierre','integer');
		$this->captura('nro_tramite_cierre','varchar');
		$this->captura('estado_cierre','varchar');
		$this->captura('id_proceso_wf','integer');
		$this->captura('id_estado_wf','integer');
		$this->captura('nro_tramite','varchar');
		$this->captura('estado','varchar');
		$this->captura('id_proceso_wf_cbte_1','int4');
		$this->captura('id_proceso_wf_cbte_2','int4');
		$this->captura('id_proceso_wf_cbte_3','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		//echo $this->consulta;exit;
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function insertarProyecto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_proyecto_ime';
		$this->transaccion='PRO_PROY_INS';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');

		$this->setParametro('id_fase_plantilla','id_fase_plantilla','int4');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_depto_conta','id_depto_conta','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function modificarProyecto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_proyecto_ime';
		$this->transaccion='PRO_PROY_MOD';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_proyecto','id_proyecto','int4');
		$this->setParametro('codigo','codigo','varchar');
		$this->setParametro('nombre','nombre','varchar');
		$this->setParametro('fecha_ini','fecha_ini','date');
		$this->setParametro('fecha_fin','fecha_fin','date');
		$this->setParametro('id_tipo_cc','id_tipo_cc','int4');
		$this->setParametro('estado_reg','estado_reg','varchar');
		$this->setParametro('id_fase_plantilla','id_fase_plantilla','int4');
		$this->setParametro('id_moneda','id_moneda','int4');
		$this->setParametro('id_depto_conta','id_depto_conta','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function eliminarProyecto(){
		//Definicion de variables para ejecucion del procedimiento
		$this->procedimiento='pro.ft_proyecto_ime';
		$this->transaccion='PRO_PROY_ELI';
		$this->tipo_procedimiento='IME';

		//Define los parametros para la funcion
		$this->setParametro('id_proyecto','id_proyecto','int4');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	 function listarProyectoTipoCC(){
		//Definicion de variables para ejecucion del procedimientp
		$this->procedimiento='pro.ft_proyecto_sel';
		$this->transaccion='PRO_PROY_TIPOCC_SEL';
		$this->tipo_procedimiento='SEL';//tipo de transaccion
		$this->setCount(false);

		//Definicion de la lista del resultado del query
		$this->captura('id_proyecto','int4');
		$this->captura('id_tipo_cc','int4');
		$this->captura('codigo','varchar');
		$this->captura('descripcion','varchar');

		//Ejecuta la instruccion
		$this->armarConsulta();
		$this->ejecutarConsulta();

		//Devuelve la respuesta
		return $this->respuesta;
	}

	function siguienteEstadoCierre(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento = 'pro.ft_proyecto_ime';
        $this->transaccion = 'PRO_SIGESTCIE_INS';
        $this->tipo_procedimiento = 'IME';

        //Define los parametros para la funcion
        $this->setParametro('id_proyecto','id_proyecto','int4');
        $this->setParametro('id_proceso_wf_act','id_proceso_wf_act','int4');
        $this->setParametro('id_estado_wf_act','id_estado_wf_act','int4');
        $this->setParametro('id_funcionario_usu','id_funcionario_usu','int4');
        $this->setParametro('id_tipo_estado','id_tipo_estado','int4');
        $this->setParametro('id_funcionario_wf','id_funcionario_wf','int4');
        $this->setParametro('id_depto_wf','id_depto_wf','int4');
        $this->setParametro('obs','obs','text');
        $this->setParametro('json_procesos','json_procesos','text');

        //Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();
        //Devuelve la respuesta
        return $this->respuesta;
    }

    function anteriorEstadoCierre(){
        //Definicion de variables para ejecucion del procedimiento
        $this->procedimiento='pro.ft_proyecto_ime';
        $this->transaccion='PRO_ANTESTCIE_IME';
        $this->tipo_procedimiento='IME';
        //Define los parametros para la funcion
        $this->setParametro('id_proceso_wf','id_proceso_wf','int4');
        $this->setParametro('id_estado_wf','id_estado_wf','int4');
		$this->setParametro('obs','obs','varchar');
		$this->setParametro('estado_destino','estado_destino','varchar');
		//Ejecuta la instruccion
        $this->armarConsulta();
        $this->ejecutarConsulta();

        //Devuelve la respuesta
        return $this->respuesta;
    }

}
?>