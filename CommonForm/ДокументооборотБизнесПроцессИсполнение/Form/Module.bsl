﻿
///////////////////////////////////////////////////////////
//// Обработка событий формы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Если открывается новая карточка бизнес-процесса
	Если Параметры.Свойство("Предмет") И ЗначениеЗаполнено(Параметры.Предмет) Тогда
		
		ЗаполнитьКарточкуНовогоБизнесПроцесса("DMBusinessProcessPerformance", ЭтаФорма, Параметры.Предмет);
		
	//Если открывается карточка имеющегося бизнес-процесса 		
	ИначеЕсли ЗначениеЗаполнено(Параметры.id)
		И ЗначениеЗаполнено(Параметры.type) Тогда
		ОбъектID = Параметры.id;
		ДанныеБП = РаботаС1СДокументооборот.ПолучитьОбъект(Параметры.type, Параметры.id);
		Объект = ДанныеБП.objects[0];
		ЗаполнитьФормуИзОбъектаXDTO(Объект);
 	КонецЕсли;	
	
	ЭтаФорма.Заголовок = Наименование;
	Если НЕ ЗначениеЗаполнено(ОбъектID) Тогда
		ЭтаФорма.Заголовок = ЭтаФорма.Заголовок + НСтр("ru = ' (Создание)'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаС1СДокументооборотКлиент.ВыбратьЗначениеИзСписка("DMBusinessProcessImportance", "Важность", ЭтаФорма); 
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Результат = ОткрытьФормуМодально("ОбщаяФорма.ДокументооборотВыборИсполнителяБизнесПроцесса",, ЭтаФорма);
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Результат.Свойство("Исполнитель", Элемент.Родитель.Родитель.ТекущиеДанные.Исполнитель);
	Результат.Свойство("ИсполнительID", Элемент.Родитель.Родитель.ТекущиеДанные.ИсполнительID);
	Результат.Свойство("ИсполнительТип", Элемент.Родитель.Родитель.ТекущиеДанные.ИсполнительТип);
	
	Результат.Свойство("ОсновнойОбъектАдресации", Элемент.Родитель.Родитель.ТекущиеДанные.ОсновнойОбъектАдресации);
	Результат.Свойство("ОсновнойОбъектАдресацииID", Элемент.Родитель.Родитель.ТекущиеДанные.ОсновнойОбъектАдресацииID);
	Результат.Свойство("ОсновнойОбъектАдресацииТип", Элемент.Родитель.Родитель.ТекущиеДанные.ОсновнойОбъектАдресацииТип);
	
	Результат.Свойство("ДополнительныйОбъектАдресации", Элемент.Родитель.Родитель.ТекущиеДанные.ДополнительныйОбъектАдресации);
	Результат.Свойство("ДополнительныйОбъектАдресацииID", Элемент.Родитель.Родитель.ТекущиеДанные.ДополнительныйОбъектАдресацииID);
	Результат.Свойство("ДополнительныйОбъектАдресацииТип", Элемент.Родитель.Родитель.ТекущиеДанные.ДополнительныйОбъектАдресацииТип);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверяющийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Результат = ОткрытьФормуМодально("ОбщаяФорма.ДокументооборотВыборИсполнителяБизнесПроцесса",, ЭтаФорма);

	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Результат.Свойство("Исполнитель", Проверяющий);
	Результат.Свойство("ИсполнительID", ПроверяющийID);
	Результат.Свойство("ИсполнительТип", ПроверяющийТип);
	
	Результат.Свойство("ОсновнойОбъектАдресации", ОсновнойОбъектАдресацииПроверяющего);
	Результат.Свойство("ОсновнойОбъектАдресацииID", ОсновнойОбъектАдресацииПроверяющегоID);
	Результат.Свойство("ОсновнойОбъектАдресацииТип", ОсновнойОбъектАдресацииПроверяющегоТип);
	
	Результат.Свойство("ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресацииПроверяющего);
	Результат.Свойство("ДополнительныйОбъектАдресацииID", ДополнительныйОбъектАдресацииПроверяющегоID);
	Результат.Свойство("ДополнительныйОбъектАдресацииТип",ДополнительныйОбъектАдресацииПроверяющегоТип);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролерНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Результат = ОткрытьФормуМодально("ОбщаяФорма.ДокументооборотВыборИсполнителяБизнесПроцесса",, ЭтаФорма);

	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Результат.Свойство("Исполнитель", Контролер);
	Результат.Свойство("ИсполнительID", КонтролерID);
	Результат.Свойство("ИсполнительТип", КонтролерТип);
	
	Результат.Свойство("ОсновнойОбъектАдресации", ОсновнойОбъектАдресацииКонтролера);
	Результат.Свойство("ОсновнойОбъектАдресацииID", ОсновнойОбъектАдресацииКонтролераID);
	Результат.Свойство("ОсновнойОбъектАдресацииТип", ОсновнойОбъектАдресацииКонтролераТип);
	
	Результат.Свойство("ДополнительныйОбъектАдресации", ДополнительныйОбъектАдресацииКонтролера);
	Результат.Свойство("ДополнительныйОбъектАдресацииID", ДополнительныйОбъектАдресацииКонтролераID);
	Результат.Свойство("ДополнительныйОбъектАдресацииТип", ДополнительныйОбъектАдресацииКонтролераТип);	
	
КонецПроцедуры

&НаКлиенте
Процедура АвторНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаС1СДокументооборотКлиент.ВыбратьПользователяИзДереваПодразделений("Автор", ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	#Если Не ВебКлиент Тогда
	Если Модифицированность Тогда
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		Режим = РежимДиалогаВопрос.ДаНетОтмена;
		Ответ = Вопрос(ТекстВопроса, Режим);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Отказ = НЕ ЗаписатьОбъектВыполнить();
		ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	#Если ВебКлиент Тогда
	Если Модифицированность Тогда
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		Режим = РежимДиалогаВопрос.ДаНет;
		Ответ = Вопрос(ТекстВопроса, Режим);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ЗаписатьОбъектВыполнить();
		КонецЕсли;
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ГлавнаяЗадачаОткрытие(Элемент, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ГлавнаяЗадача) Тогда
		ПараметрыФормы = Новый Структура("id, type", ГлавнаяЗадачаID, ГлавнаяЗадачаТип);
		ОткрытьФормуМодально("ОбщаяФорма.ДокументооборотКарточкаЗадачи", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Предмет) Тогда
		РаботаС1СДокументооборотКлиент.ОткрытьКарточкуПредметаБизнесПроцесса(ПредметТип, ПредметID, Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнителиПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Исполнители.ТекущиеДанные <> Неопределено Тогда
		Элементы.ИсполнителиОтветственныйИсполнитель.Пометка = Элементы.Исполнители.ТекущиеДанные.Ответственный;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникБизнесПроцессаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		РаботаС1СДокументооборотВызовСервера.ПолучитьДанныеДляАвтоПодбора("DMUser;DMBusinessProcessExecutorRole", Данныевыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникБизнесПроцессаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
		
	Если ЗначениеЗаполнено(Текст) Тогда
		РаботаС1СДокументооборотВызовСервера.ПолучитьДанныеДляАвтоПодбора("DMUser;DMBusinessProcessExecutorRole", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда
			Если Элемент = Элементы.Проверяющий  Тогда
			    РаботаС1СДокументооборотКлиент.ПрименитьВыборУчастникаБизнесПроцессаВПоле("Проверяющий", "ОбъектАдресацииПроверяющего", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма);
			ИначеЕсли Элемент = Элементы.Контролер Тогда
				РаботаС1СДокументооборотКлиент.ПрименитьВыборУчастникаБизнесПроцессаВПоле("Контролер", "ОбъектАдресацииКонтролера", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма);
			Иначе
				РаботаС1СДокументооборотКлиент.ПрименитьВыборУчастникаБизнесПроцессаВСписке(Элемент.Родитель.Родитель, ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма);
			КонецЕсли;
			СтандартнаяОбработка = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		РаботаС1СДокументооборотВызовСервера.ПолучитьДанныеДляАвтоПодбора("DMBusinessProcessImportance", Данныевыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		РаботаС1СДокументооборотВызовСервера.ПолучитьДанныеДляАвтоПодбора("DMBusinessProcessImportance", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			РаботаС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора("Важность", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВажностьОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора("Важность", ВыбранноеЗначение, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникБизнесПроцессаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаС1СДокументооборотКлиент.ПрименитьВыборУчастникаБизнесПроцессаВСписке(Элемент.Родитель.Родитель, ВыбранноеЗначение, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверяющийОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаС1СДокументооборотКлиент.ПрименитьВыборУчастникаБизнесПроцессаВПоле("Проверяющий", "ОбъектАдресацииПроверяющего", ВыбранноеЗначение, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтролерОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаС1СДокументооборотКлиент.ПрименитьВыборУчастникаБизнесПроцессаВПоле("Контролер", "ОбъектАдресацииКонтролера", ВыбранноеЗначение, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокДатаПриИзменении(Элемент)
	
	Если Срок = НачалоДня(Срок) Тогда
		Срок = КонецДня(Срок);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Изменен" И Параметр = Элементы.Предмет Тогда 
		Предмет = Источник.Представление;
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура АвторАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		РаботаС1СДокументооборотВызовСервера.ПолучитьДанныеДляАвтоПодбора("DMUser", Данныевыбора, Текст, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвторОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		РаботаС1СДокументооборотВызовСервера.ПолучитьДанныеДляАвтоПодбора("DMUser", ДанныеВыбора, Текст, СтандартнаяОбработка);
		
		Если ДанныеВыбора.Количество() = 1 Тогда 
			РаботаС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора("Автор", ДанныеВыбора[0].Значение, СтандартнаяОбработка, ЭтаФорма);
			СтандартнаяОбработка = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвторОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РаботаС1СДокументооборотКлиент.ОбработкаВыбораДанныхДляАвтоПодбора("Автор", ВыбранноеЗначение, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

///////////////////////////////////////////////////////////
//// Обработка команд формы

&НаКлиенте
Процедура Записать(Команда)
	
	РезультатЗаписи = ЗаписатьОбъектВыполнить();
	
	Если РезультатЗаписи Тогда
		ПараметрыОповещения = Новый Структура("id", ОбъектID);
		Оповестить("БизнесПроцессИзменен", ПараметрыОповещения);
		ЭтаФорма.Заголовок = Наименование;
		Состояние(НСтр("ru = 'Бизнес-процесс """ + Наименование + """ сохранен.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтартоватьИЗакрыть(Команда)
	
	РезультатЗапуска = ПодготовитьКПередачеИСтартоватьБизнесПроцесс();
	Если РезультатЗапуска Тогда
		ПараметрыОповещения = Новый Структура("id", ОбъектID);
		Оповестить("БизнесПроцессИзменен", ПараметрыОповещения);
		
		ТекстСостояния = НСтр("ru = 'Бизнес-процесс """ + Наименование + """ успешно запущен.'");
		Состояние(ТекстСостояния);
		
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоШаблону(Команда)
	
	РезультатВыбораШаблона = РаботаС1СДокументооборотКлиент.ВыбратьШаблонБизнесПроцесса(ЭтаФорма);
	Если ТипЗнч(РезультатВыбораШаблона) = Тип("Структура") Тогда
		ЗаполнитьКарточкуПоШаблону(РезультатВыбораШаблона);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйИсполнитель(Команда)
	
	Если Элементы.Исполнители.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Ответственный = Элементы.Исполнители.ТекущиеДанные.Ответственный;
	Для каждого СтрокаТаблицы Из Исполнители Цикл
		СтрокаТаблицы.Ответственный = Ложь;
	КонецЦикла;
	
	Элементы.Исполнители.ТекущиеДанные.Ответственный = НЕ Ответственный;
	Элементы.ИсполнителиОтветственныйИсполнитель.Пометка = Элементы.Исполнители.ТекущиеДанные.Ответственный;
	
КонецПроцедуры


///////////////////////////////////////////////////////////
//// Служебные процедуры и функции

&НаСервере
Процедура ЗаполнитьКарточкуПоШаблону(ДанныеШаблона)
	
	РезультатЗаполнения = РаботаС1СДокументооборотВызовСервера.ЗаполнитьБизнесПроцессПоШаблону(ЭтаФорма, ДанныеШаблона);
	ЗаполнитьФормуИзОбъектаXDTO(РезультатЗаполнения.object);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКарточкуНовогоБизнесПроцесса(ТипБизнесПроцесса, Форма, Предмет)	
	
	НовыйОбъект = РаботаС1СДокументооборот.ПолучитьНовыйОбъект(ТипБизнесПроцесса, Предмет);
	ЗаполнитьФормуИзОбъектаXDTO(НовыйОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуИзОбъектаXDTO(Объект) 
	
	РаботаС1СДокументооборот.УстановитьСтандартнуюШапкуБизнесПроцесса(Объект, Этаформа);
	РаботаС1СДокументооборот.УстановитьКонтролераНаКарточке(Объект, Этаформа);
    РаботаС1СДокументооборот.УстановитьПроверяющегоНаКарточке(Объект, Этаформа);
	Исполнители.Очистить();
	Для Каждого Исполнитель Из Объект.performers Цикл
		НоваяСтрока = Исполнители.Добавить();
		РаботаС1СДокументооборот.УстановитьИсполнителяВСпискеИсполнителейНаКарточке(Исполнитель, НоваяСтрока);
		НоваяСтрока.Срок = Исполнитель.personalDueDate;
		НоваяСтрока.ОписаниеПоручения = Исполнитель.personalDescription;
		НоваяСтрока.НаименованиеПоручения = Исполнитель.personalTaskName;
		НоваяСтрока.Ответственный = Исполнитель.responsible; 
	КонецЦикла;
	
	Элементы.Исполнители.ПодчиненныеЭлементы.ИсполнителиВремя.Видимость = Объект.dueTimeEnabled;
	Элементы.ИсполнителиОтветственныйИсполнитель.Доступность = НЕ ЭтаФорма.ТолькоПросмотр;
	
КонецПроцедуры

&НаСервере
Процедура СоздатьСвойствоОбъектаXDTOИзРеквизитаФормы(ИмяРеквизитаФормы, ОбъектXDTO, ИмяСвойстаОбъекта, ТипСвойстваОбъекта, Прокси)
	
	ОбъектXDTO[ИмяСвойстаОбъекта] = СоздатьОбъект(Прокси, ТипСвойстваОбъекта);
	ОбъектXDTO[ИмяСвойстаОбъекта].name = ЭтаФорма[ИмяРеквизитаФормы];
	ОбъектXDTO[ИмяСвойстаОбъекта].objectId = СоздатьОбъект(Прокси, "DMObjectID");
	ОбъектXDTO[ИмяСвойстаОбъекта].objectId.id = ЭтаФорма[ИмяРеквизитаФормы + "id"];
	ОбъектXDTO[ИмяСвойстаОбъекта].objectId.type = ЭтаФорма[ИмяРеквизитаФормы + "Тип"];
	
КонецПроцедуры

&НаСервере
Функция СоздатьОбъект(Прокси, Тип)
	
	Возврат РаботаС1СДокументооборотВызовСервера.СоздатьОбъектDM(Прокси, Тип);
	
КонецФункции

&НаСервере
Процедура СоздатьУчастникаБизнесПроцесса(Прокси, Объект, Форма, ИмяРеквизита, ИмяРеквизитаАдресации)
	
	Если ЗначениеЗаполнено(Форма[ИмяРеквизита]) Тогда 
		Объект = СоздатьОбъект(Прокси, "DMBusinessProcessTaskExecutor");
		Если Форма[ИмяРеквизита + "Тип"] = "DMUser" Тогда
			Объект.user = СоздатьОбъект(Прокси, "DMUser");
			Объект.user.name = Форма[ИмяРеквизита];
			Объект.user.objectId = СоздатьОбъект(Прокси, "DMObjectID");
			Объект.user.objectId.id = Форма[ИмяРеквизита + "id"];
			Объект.user.objectId.type = Форма[ИмяРеквизита + "Тип"];
		Иначе
			Объект.role = СоздатьОбъект(Прокси, "DMBusinessProcessExecutorRole");
			Объект.role.name = Форма[ИмяРеквизита];
			Объект.role.objectId = СоздатьОбъект(Прокси, "DMObjectID");
			Объект.role.objectId.id = Форма[ИмяРеквизита + "id"];
			Объект.role.objectId.type = Форма[ИмяРеквизита + "Тип"];
			
			Если ЗначениеЗаполнено(Форма["Основной" + ИмяРеквизитаАдресации]) Тогда
				Объект.mainAddressingObject = СоздатьОбъект(Прокси, "DMMainAddressingObject");
				Объект.mainAddressingObject.name = Форма["Основной" + ИмяРеквизитаАдресации];
				Объект.mainAddressingObject.objectId = СоздатьОбъект(Прокси, "DMObjectID");
				Объект.mainAddressingObject.objectId.id = Форма["Основной" + ИмяРеквизитаАдресации + "id"];
				Объект.mainAddressingObject.objectId.type = Форма["Основной" + ИмяРеквизитаАдресации + "Тип"];
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Форма["Дополнительный" + ИмяРеквизитаАдресации]) Тогда
				Объект.secondaryAddressingObject = СоздатьОбъект(Прокси, "DMSecondaryAddressingObject");
				Объект.secondaryAddressingObject.name = Форма["Дополнительный" + ИмяРеквизитаАдресации];
				Объект.secondaryAddressingObject.objectId = СоздатьОбъект(Прокси, "DMObjectID");
				Объект.secondaryAddressingObject.objectId.id = Форма["Дополнительный" + ИмяРеквизитаАдресации + "id"];
				Объект.secondaryAddressingObject.objectId.type = Форма["Дополнительный" + ИмяРеквизитаАдресации + "Тип"];
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьКПередачеИЗаписатьБизнесПроцесс()
	
	Прокси = РаботаС1СДокументооборотВызовСервера.ПолучитьПрокси();
	Объект = ПодготовитьБизнесПроцесс(Прокси);
	Если ЗначениеЗаполнено(ОбъектID) Тогда
		РезультатЗаписи = РаботаС1СДокументооборот.ЗаписатьОбъект(Прокси, Объект);
	Иначе
		РезультатСоздания = РаботаС1СДокументооборот.СоздатьНовыйОбъект(Прокси, Объект);
	КонецЕсли;
	
	Результат = ?(РезультатСоздания = Неопределено, РезультатЗаписи, РезультатСоздания);
	Если РаботаС1СДокументооборот.ПроверитьТип(Прокси, Результат , "DMError") Тогда
		ВызватьИсключение(РезультатСоздания.description);
	Иначе
		Если РезультатЗаписи <> Неопределено Тогда
			ОбъектID = Результат.objects[0].objectId.id;
		Иначе
			ОбъектID = Результат.object.objectId.id;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ПодготовитьКПередачеИСтартоватьБизнесПроцесс()
	
	Прокси = РаботаС1СДокументооборотВызовСервера.ПолучитьПрокси();
	Объект = ПодготовитьБизнесПроцесс(Прокси);
	РезультатЗапуска = РаботаС1СДокументооборот.ЗапуститьБизнесПроцесс(Прокси, Объект); 	
	
	Если РаботаС1СДокументооборот.ПроверитьТип(Прокси, РезультатЗапуска, "DMError") Тогда
		ВызватьИсключение(РезультатЗапуска.description); 
	Иначе
		ОбъектID = РезультатЗапуска.businessProcess.objectId.id;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ПодготовитьБизнесПроцесс(Прокси)
		
	Объект = СоздатьОбъект(Прокси, "DMBusinessProcessPerformance");
	
	Объект.name = Наименование;
	Объект.objectId = СоздатьОбъект(Прокси, "DMObjectID"); 
	Объект.objectId.id = ОбъектID;
	Объект.objectId.type = "DMBusinessProcessPerformance";
	
	//Общая шапка бизнес-процессов
	СоздатьСвойствоОбъектаXDTOИзРеквизитаФормы("Автор", Объект, "author", "DMUser", Прокси);	
	СоздатьСвойствоОбъектаXDTOИзРеквизитаФормы("Важность", Объект, "importance", "DMBusinessProcessImportance", Прокси);
    СоздатьСвойствоОбъектаXDTOИзРеквизитаФормы("Предмет", Объект, "target", "DMObject", Прокси);
	
	Объект.beginDate = ДатаНачала;
	Объект.started = Стартован;
	Объект.completed = Завершен;
	Объект.description = Описание;
	Объект.dueDate = Срок;
	
	//специфика Исполнения
	
	//контролер
	СоздатьУчастникаБизнесПроцесса(Прокси, Объект.controller, ЭтаФорма, "Контролер", "ОбъектАдресацииКонтролера");
	
	//проверяющий
	СоздатьУчастникаБизнесПроцесса(Прокси, Объект.verifier, ЭтаФорма, "Проверяющий", "ОбъектАдресацииПроверяющего");	
	
	//исполнители
	Для Каждого Строка Из Исполнители Цикл 
		
		Исполнитель = СоздатьОбъект(Прокси, "DMBusinessProcessPerformanceParticipant");
				
		Если Строка.ИсполнительТип = "DMUser" Тогда
			Исполнитель.user = СоздатьОбъект(Прокси, "DMUser");
			Исполнитель.user.name = Строка.Исполнитель;
			Исполнитель.user.objectId = СоздатьОбъект(Прокси, "DMObjectID");
			Исполнитель.user.objectId.id = Строка.ИсполнительID;
			Исполнитель.user.objectId.type = Строка.ИсполнительТип;
		Иначе
			Исполнитель.role = СоздатьОбъект(Прокси, "DMBusinessProcessExecutorRole");
			Исполнитель.role.name = Строка.Исполнитель;
			Исполнитель.role.objectId = СоздатьОбъект(Прокси, "DMObjectID");
			Исполнитель.role.objectId.id = Строка.ИсполнительID;
			Исполнитель.role.objectId.type = Строка.ИсполнительТип;
			
			Если ЗначениеЗаполнено(Строка.ОсновнойОбъектАдресации) Тогда
				Исполнитель.mainAddressingObject = СоздатьОбъект(Прокси, "DMMainAddressingObject");
				Исполнитель.mainAddressingObject.name = Строка.ОсновнойОбъектАдресации;
				Исполнитель.mainAddressingObject.objectId = СоздатьОбъект(Прокси, "DMObjectID");
				Исполнитель.mainAddressingObject.objectId.id = Строка.ОсновнойОбъектАдресацииID;
				Исполнитель.mainAddressingObject.objectId.type = Строка.ОсновнойОбъектАдресацииТип;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Строка.ДополнительныйОбъектАдресации) Тогда
				Исполнитель.secondaryAddressingObject = СоздатьОбъект(Прокси, "DMSecondaryAddressingObject");
				Исполнитель.secondaryAddressingObject.name = Строка.ДополнительныйОбъектАдресации;
				Исполнитель.secondaryAddressingObject.objectId = СоздатьОбъект(Прокси, "DMObjectID");
				Исполнитель.secondaryAddressingObject.objectId.id = Строка.ДополнительныйОбъектАдресацииID;
				Исполнитель.secondaryAddressingObject.objectId.type = Строка.ДополнительныйОбъектАдресацииТип;
			КонецЕсли;
		КонецЕсли;
		
		Исполнитель.personalDueDate = Строка.Срок;
		Исполнитель.personalDescription = Строка.ОписаниеПоручения;
		Исполнитель.personalTaskName = Строка.НаименованиеПоручения;
		Исполнитель.responsible = Строка.Ответственный;
		Объект.performers.Добавить(Исполнитель);
		
	КонецЦикла;
	
	Возврат Объект;
	
КонецФункции

&НаКлиенте
Функция ЗаписатьОбъектВыполнить()
	
	ПодготовитьКПередачеИЗаписатьБизнесПроцесс();
	Модифицированность = Ложь;
	Возврат Истина;
	
КонецФункции

















                                                                                 


















