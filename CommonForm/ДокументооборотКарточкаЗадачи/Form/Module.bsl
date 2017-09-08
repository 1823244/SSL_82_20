﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	HTMLпредставление = ПолучитьHTMLПредставлениеФормыЗадачи(Параметры.Type, Параметры.ID)
	
КонецПроцедуры

&НаСервере
Функция ПолучитьHTMLПредставлениеФормыЗадачи(Тип, Ид)
	
	Колонки = Новый Массив();
	Колонки.Добавить("HTMLView");
	Ответ = РаботаС1СДокументооборот.ПолучитьОбъект(Тип, Ид, Колонки);
	ЗадачаID = Ответ.objects[0].objectId.id;
	ЗадачаТип = Ответ.objects[0].objectId.type;
	Заголовок = "Задача """ + Ответ.objects[0].name + """";
	Возврат Ответ.objects[0].htmlView;
	
КонецФункции

&НаКлиенте
Процедура HTMLпредставлениеПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ДанныеСобытия.Anchor <> Неопределено И ЗначениеЗаполнено(ДанныеСобытия.Anchor.href) Тогда
		
		МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ДанныеСобытия.Anchor.href, "/");
		
		СтрокаСсылка = МассивПодстрок[МассивПодстрок.Количество() - 1];
		
		МассивПараметров = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаСсылка, "$");
		
		Type = МассивПараметров[0];
		ID = МассивПараметров[1];
		
		РаботаС1СДокументооборотКлиент.ОткрытьКарточкуПредметаБизнесПроцесса(Type, ID, ЭтаФорма, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьБизнесПроцесс(Команда)
	
	ПараметрыБизнесПроцесса = Новый Структура;
	ТипБизнесПроцесса = "";
	ПолучитьБизнесПроцесс(ТипБизнесПроцесса, ПараметрыБизнесПроцесса);
	РаботаС1СДокументооборотКлиент.ПоказатьФормуБизнесПроцесса(ТипБизнесПроцесса, ПараметрыБизнесПроцесса);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьБизнесПроцесс(ТипБизнесПроцесса, ПараметрыБизнесПроцесса)
	
	ДанныеЗадачи = РаботаС1СДокументооборот.ПолучитьОбъект(ЗадачаТип, ЗадачаID);
	ТипБизнесПроцесса = ДанныеЗадачи.objects[0].parentBusinessProcess.objectId.type;
	
	ПараметрыБизнесПроцесса.Вставить("id", ДанныеЗадачи.objects[0].parentBusinessProcess.objectId.id);
	ПараметрыБизнесПроцесса.Вставить("type", ТипБизнесПроцесса);
	
КонецПроцедуры


