﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПродолжитьЗагрузкуДанных(Команда)
	
	Если РазделительСуществует(ЗначениеРазделителя) Тогда
		Текст = НСтр("ru = 'Указанная область данных существует. Загрузка может привести к порче текущих данных.
			|Продолжить загрузку?'");
		Результат = Вопрос(Текст, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
		
		Если Результат = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	АдресВХранилище = Неопределено;
	Если НЕ ПоместитьФайл(АдресВХранилище) Тогда
		Возврат;
	КонецЕсли;
	
	Состояние(НСтр("ru = 'Выполняется загрузка данных в область'"));
	Попытка
		ЗагрузитьДанныеНаСервере(АдресВХранилище, ЗначениеРазделителя);
		
		Пользователи.АвторизоватьТекущегоПользователя();
		
		ОбновлениеИнформационнойБазы.ВыполнитьОбновлениеИнформационнойБазы(Истина);
		
		Отказ = Ложь;
		
		СтандартныеПодсистемыКлиент.ДействияПередНачаломРаботыСистемы(Отказ);
		
		Если Отказ Тогда
			Предупреждение(НСтр("ru = 'Загрузка данных завершена с ошибками'"));
			Возврат;
		КонецЕсли;
		
		СтандартныеПодсистемыКлиент.ДействияПриНачалеРаботыСистемы();
		
		Состояние(НСтр("ru = 'Загрузка данных завершена успешно'"));
	Исключение
		Предупреждение(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗагрузитьДанныеНаСервере(Знач АдресВХранилище, ЗначениеРазделителя)
	
	ДанныеАрхива = ПолучитьИзВременногоХранилища(АдресВХранилище);
	ИмяАрхива = ПолучитьИмяВременногоФайла("zip");
	ДанныеАрхива.Записать(ИмяАрхива);
	ДанныеАрхива = Неопределено;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбщегоНазначения.УстановитьРазделениеСеанса(Истина, ЗначениеРазделителя);
	
	Если НЕ РазделительСуществует(ЗначениеРазделителя) Тогда
		МенеджерЗаписи = РегистрыСведений.ОбластиДанных.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ОбластьДанных = ЗначениеРазделителя;
		МенеджерЗаписи.Представление = ЗначениеРазделителя;
		МенеджерЗаписи.Статус        = Перечисления.СтатусыОбластейДанных.Используется;
		МенеджерЗаписи.Записать();
	КонецЕсли;
	
	ВыгрузкаЗагрузкаДанных.ЗагрузитьТекущуюОбластьИзАрхива(ИмяАрхива);
	
	Попытка
		УдалитьФайлы(ИмяАрхива);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Удаление временных файлов'"),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Функция РазделительСуществует(ЗначениеРазделителя)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОбластиДанных.ОбластьДанных
	|ИЗ
	|	РегистрСведений.ОбластиДанных КАК ОбластиДанных
	|ГДЕ
	|	ОбластиДанных.ОбластьДанных = &ОбластьДанных";
	Запрос.УстановитьПараметр("ОбластьДанных", ЗначениеРазделителя);
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции
