﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗагрузитьКлассификатор(Команда)
	ОткрытьФорму("Справочник.КлассификаторБанковРФ.Форма.ЗагрузкаКлассификатора");
КонецПроцедуры



