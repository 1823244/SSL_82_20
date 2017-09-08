﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Перем КлючЗаписи;
	
	Пользователь = Пользователи.ТекущийПользователь();
	
	ДанныеКлючаЗаписи = Новый  Структура("УчетнаяЗаписьЭлектроннойПочты",ПараметрКоманды);
	
	Если ЗаписьСуществует(ДанныеКлючаЗаписи) Тогда
		МассивПараметровКонструктора = Новый Массив();
		МассивПараметровКонструктора.Добавить(ДанныеКлючаЗаписи);
		
		КлючЗаписи = Новый("РегистрСведенийКлючЗаписи.НастройкиУчетныхЗаписейЭлектроннойПочты", МассивПараметровКонструктора);
	КонецЕсли;
	
	ОткрытьФорму("РегистрСведений.НастройкиУчетныхЗаписейЭлектроннойПочты.ФормаЗаписи",
	             Новый Структура("Ключ,ЗначенияЗаполнения",
	             КлючЗаписи,ДанныеКлючаЗаписи),
	             ПараметрыВыполненияКоманды.Источник,
	             ПараметрыВыполненияКоманды.Уникальность,
	             ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

&НаСервере
Функция ЗаписьСуществует(Параметры)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	НастройкиУчетныхЗаписейЭлектроннойПочты.УчетнаяЗаписьЭлектроннойПочты
	|ИЗ
	|	РегистрСведений.НастройкиУчетныхЗаписейЭлектроннойПочты КАК НастройкиУчетныхЗаписейЭлектроннойПочты
	|ГДЕ
	|	НастройкиУчетныхЗаписейЭлектроннойПочты.УчетнаяЗаписьЭлектроннойПочты = &УчетнаяЗаписьЭлектроннойПочты";
	
	Запрос.УстановитьПараметр("УчетнаяЗаписьЭлектроннойПочты",Параметры.УчетнаяЗаписьЭлектроннойПочты);
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

