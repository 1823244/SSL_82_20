﻿////////////////////////////////////////////////////////////////////////////////
// ОбработчикКаналовСообщенийОбменаДаннымиВРежимеСервиса.
//
////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Получает список обработчиков сообщений, которые обрабатывает данная подсистема.
// 
// Параметры:
//  Обработчики - ТаблицаЗначений - состав полей см. в ОбменСообщениями.НоваяТаблицаОбработчиковСообщений
// 
Процедура ПолучитьОбработчикиКаналовСообщений(Обработчики) Экспорт
	
	ДобавитьОбработчикКаналаСообщений("ОбменДанными\ПрикладноеПриложение\СозданиеОбмена", ОбработчикКаналовСообщенийОбменаДаннымиВРежимеСервиса, Обработчики);
	ДобавитьОбработчикКаналаСообщений("ОбменДанными\ПрикладноеПриложение\УдалениеОбмена", ОбработчикКаналовСообщенийОбменаДаннымиВРежимеСервиса, Обработчики);
	ДобавитьОбработчикКаналаСообщений("ОбменДанными\ПрикладноеПриложение\УстановитьПрефиксОбластиДанных", ОбработчикКаналовСообщенийОбменаДаннымиВРежимеСервиса, Обработчики);
	
КонецПроцедуры

// Выполняет обработку тела сообщения из канала в соответствии с алгоритмом текущего канала сообщений
//
// Параметры:
//  КаналСообщений (обязательный) - Строка - Идентификатор канала сообщений, из которого получено сообщение.
//  ТелоСообщения (обязательный) - Произвольный - Тело сообщения, полученное из канала, которое подлежит обработке.
//  Отправитель (обязательный) - ПланОбменаСсылка.ОбменСообщениями - Конечная точка, которая является отправителем сообщения.
//
Процедура ОбработатьСообщение(КаналСообщений, ТелоСообщения, Отправитель) Экспорт
	
	УстановитьОбластьДанных(ТелоСообщения.ОбластьДанных);
	
	Если КаналСообщений = "ОбменДанными\ПрикладноеПриложение\СозданиеОбмена" Тогда
		
		СоздатьОбменДаннымиВИнформационнойБазе(
								Отправитель,
								ТелоСообщения.Настройки,
								ТелоСообщения.НастройкаОтборовНаУзле,
								ТелоСообщения.ЗначенияПоУмолчаниюНаУзле,
								ТелоСообщения.КодЭтогоУзла,
								ТелоСообщения.КодНовогоУзла
		);
		
	ИначеЕсли КаналСообщений = "ОбменДанными\ПрикладноеПриложение\УдалениеОбмена" Тогда
		
		УдалитьОбменДаннымиВИнформационнойБазе(Отправитель, ТелоСообщения.ИмяПланаОбмена, ТелоСообщения.КодУзла);
		
	ИначеЕсли КаналСообщений = "ОбменДанными\ПрикладноеПриложение\УстановитьПрефиксОбластиДанных" Тогда
		
		УстановитьПрефиксОбластиДанных(ТелоСообщения.Префикс);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура СоздатьОбменДаннымиВИнформационнойБазе(Отправитель, Настройки, НастройкаОтборовНаУзле, ЗначенияПоУмолчаниюНаУзле, КодЭтогоУзла, КодНовогоУзла)
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Создаем каталог обмена сообщениями (при необходимости)
	Каталог = Новый Файл(Настройки.FILEКаталогОбменаИнформацией);
	
	Если Не Каталог.Существует() Тогда
		
		Попытка
			СоздатьКаталог(Каталог.ПолноеИмя);
		Исключение
			
			СтрокаСообщенияОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			
			// Отмечаем в управляющем приложении ошибку выполнения операции
			ОтправитьСообщениеОшибкаПриСозданииОбмена(Число(КодЭтогоУзла), Число(КодНовогоУзла), СтрокаСообщенияОбОшибке, Отправитель);
			
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен данными'"), УровеньЖурналаРегистрации.Ошибка,,, СтрокаСообщенияОбОшибке);
			Возврат;
		КонецПопытки;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОбменДанными") <> Истина Тогда
		Константы.ИспользоватьОбменДанными.Установить(Истина);
	КонецЕсли;
	
	Настройки.Вставить("ВидТранспортаСообщенийОбмена", Перечисления.ВидыТранспортаСообщенийОбмена.Combi);
	Настройки.Вставить("CombiВидТранспортаСообщенийОбмена", Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
	Настройки.Вставить("ВариантРаботыМастера", "");
	Настройки.Вставить("ПарольАрхиваСообщенияОбмена", "");
	Настройки.Вставить("ИспользоватьПараметрыТранспортаEMAIL", Ложь);
	Настройки.Вставить("ИспользоватьПараметрыТранспортаFILE", Ложь);
	Настройки.Вставить("ИспользоватьПараметрыТранспортаFTP", Ложь);
	Настройки.Вставить("FILEСжиматьФайлИсходящегоСообщения", Ложь);
	Настройки.Вставить("ПрефиксИнформационнойБазыИсточникаУстановлен", ЗначениеЗаполнено(ПолучитьФункциональнуюОпцию("ПрефиксИнформационнойБазы")));
	Настройки.Вставить("ЭтоНастройкаРаспределеннойИнформационнойБазы", Ложь);
	
	ПомощникСозданияОбменаДанными = Обработки.ПомощникСозданияОбменаДанными.Создать();
	
	ЗаполнитьЗначенияСвойств(ПомощникСозданияОбменаДанными, Настройки);
	
	Отказ = Ложь;
	
	КодЭтогоУзлаВСервисе = ОбменДаннымиВМоделиСервиса.КодУзлаПланаОбменаВСервисе(Число(КодЭтогоУзла));
	КодНовогоУзлаВСервисе = ОбменДаннымиВМоделиСервиса.КодУзлаПланаОбменаВСервисе(Число(КодНовогоУзла));
	
	ПомощникСозданияОбменаДанными.ВыполнитьДействияПоНастройкеНовогоОбменаДаннымиВСервисе(
		Отказ,
		НастройкаОтборовНаУзле,
		ЗначенияПоУмолчаниюНаУзле,
		КодЭтогоУзлаВСервисе,
		КодНовогоУзлаВСервисе
	);
	
	Если Отказ Тогда
		
		СтрокаСообщенияОбОшибке = ПомощникСозданияОбменаДанными.СтрокаСообщенияОбОшибке();
		
		// Отмечаем в управляющем приложении ошибку выполнения операции
		ОтправитьСообщениеОшибкаПриСозданииОбмена(Число(КодЭтогоУзла), Число(КодНовогоУзла), СтрокаСообщенияОбОшибке, Отправитель);
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен данными'"), УровеньЖурналаРегистрации.Ошибка,,, СтрокаСообщенияОбОшибке);
		Возврат;
	КонецЕсли;
	
	// Отмечаем успешное выполнение операции в управляющем приложении
	ОтправитьСообщениеУспешноеВыполнениеОперации(Число(КодЭтогоУзла), Число(КодНовогоУзла), Отправитель);
	
КонецПроцедуры

Процедура УдалитьОбменДаннымиВИнформационнойБазе(Отправитель, ИмяПланаОбмена, КодУзла)
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Поиск узла по формату кода узла "S00000123"
	УзелИнформационнойБазы = ПланыОбмена[ИмяПланаОбмена].НайтиПоКоду(ОбменДаннымиВМоделиСервиса.КодУзлаПланаОбменаВСервисе(Число(КодУзла)));
	
	Если УзелИнформационнойБазы.Пустая() Тогда
		
		// Поиск узла по формату кода узла "0000123" (старый формат)
		УзелИнформационнойБазы = ПланыОбмена[ИмяПланаОбмена].НайтиПоКоду(КодУзла);
		
	КонецЕсли;
	
	КодЭтогоУзла = ОбменДаннымиПовтИсп.ПолучитьКодЭтогоУзлаДляПланаОбмена(ИмяПланаОбмена);
	КодЭтогоУзла = ОбменДаннымиСервер.НомерОбластиИзКодаУзлаПланаОбмена(КодЭтогоУзла);
	
	Если УзелИнформационнойБазы.Пустая() Тогда
		
		// Отмечаем успешное выполнение операции в управляющем приложении
		ОтправитьСообщениеУспешноеВыполнениеОперации(КодЭтогоУзла, Число(КодУзла), Отправитель);
		
		Возврат; // настройка обмена не найдена (возможно, была удалена ранее)
	КонецЕсли;
	
	// Удаляем ссылку на узел из всех сценариев обменов данными
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СценарииОбменовДаннымиНастройкиОбмена.Ссылка КАК СценарийОбменаДанными
	|ИЗ
	|	Справочник.СценарииОбменовДанными.НастройкиОбмена КАК СценарииОбменовДаннымиНастройкиОбмена
	|ГДЕ
	|	СценарииОбменовДаннымиНастройкиОбмена.УзелИнформационнойБазы = &УзелИнформационнойБазы
	|";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("УзелИнформационнойБазы", УзелИнформационнойБазы);
	Запрос.Текст = ТекстЗапроса;
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			СценарийОбменаДанными = Выборка.СценарийОбменаДанными.ПолучитьОбъект();
			
			Справочники.СценарииОбменовДанными.УдалитьВыгрузкуВСценарииОбменаДанными(СценарийОбменаДанными, УзелИнформационнойБазы);
			Справочники.СценарииОбменовДанными.УдалитьЗагрузкуВСценарииОбменаДанными(СценарийОбменаДанными, УзелИнформационнойБазы);
			
			Попытка
				
				СценарийОбменаДанными.Записать();
				
				Если СценарийОбменаДанными.НастройкиОбмена.Количество() = 0 Тогда
					
					СценарийОбменаДанными.Удалить();
					
				КонецЕсли;
				
			Исключение
				
				СтрокаСообщенияОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				
				// Отмечаем в управляющем приложении ошибку выполнения операции
				ОтправитьСообщениеОшибкаПриУдаленииОбмена(КодЭтогоУзла, Число(КодУзла), СтрокаСообщенияОбОшибке, Отправитель);
				
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен данными'"), УровеньЖурналаРегистрации.Ошибка,,, СтрокаСообщенияОбОшибке);
				Возврат;
			КонецПопытки;
			
		КонецЦикла;
		
	КонецЕсли;
	
	// Удаляем каталог обмена
	FILEКаталогОбменаИнформацией = РегистрыСведений.НастройкиТранспортаОбмена.ИмяКаталогаОбменаИнформацией(Перечисления.ВидыТранспортаСообщенийОбмена.FILE, УзелИнформационнойБазы);
	
	Попытка
		УдалитьФайлы(FILEКаталогОбменаИнформацией);
	Исключение
	КонецПопытки;
	
	// Удаляем узел
	Попытка
		УзелИнформационнойБазы.ПолучитьОбъект().Удалить();
	Исключение
		
		СтрокаСообщенияОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		// Отмечаем в управляющем приложении ошибку выполнения операции
		ОтправитьСообщениеОшибкаПриУдаленииОбмена(КодЭтогоУзла, Число(КодУзла), СтрокаСообщенияОбОшибке, Отправитель);
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обмен данными'"), УровеньЖурналаРегистрации.Ошибка,,, СтрокаСообщенияОбОшибке);
		Возврат;
	КонецПопытки;
	
	// Выключаем использование обмена данными, при необходимости
	ОбменДаннымиИспользуется = ОбменДаннымиСервер.ПолучитьИспользуемыеПланыОбмена().Количество() > 0;
	
	Если Не ОбменДаннымиИспользуется Тогда
		
		Константы.ИспользоватьОбменДанными.Установить(Ложь);
		
	КонецЕсли;
	
	// Отмечаем успешное выполнение операции в управляющем приложении
	ОтправитьСообщениеУспешноеВыполнениеОперации(КодЭтогоУзла, Число(КодУзла), Отправитель);
	
КонецПроцедуры

Процедура УстановитьПрефиксОбластиДанных(Знач Префикс)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПустаяСтрока(Константы.ПрефиксУзлаРаспределеннойИнформационнойБазы.Получить()) Тогда
		
		Константы.ПрефиксУзлаРаспределеннойИнформационнойБазы.Установить(Формат(Префикс, "ЧЦ=2; ЧВН=; ЧГ=0"));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьОбластьДанных(Знач ОбластьДанных)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбщегоНазначения.УстановитьРазделениеСеанса(Истина, ОбластьДанных);
	
КонецПроцедуры

Процедура ОтправитьСообщениеУспешноеВыполнениеОперации(Код1, Код2, КонечнаяТочка)
	
	НачатьТранзакцию();
	Попытка
		
		ТелоСообщения = Новый Структура("Код1, Код2", Код1, Код2);
		
		ОбменСообщениями.ОтправитьСообщение("ОбменДанными\ПрикладноеПриложение\Ответ\УспешноеВыполнениеОперации", ТелоСообщения, КонечнаяТочка);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка сообщений'"), 
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Процедура ОтправитьСообщениеОшибкаПриСозданииОбмена(Код1, Код2, СтрокаОшибки, КонечнаяТочка)
	
	НачатьТранзакцию();
	Попытка
		
		ТелоСообщения = Новый Структура("Код1, Код2, СтрокаОшибки", Код1, Код2, СтрокаОшибки);
		
		ОбменСообщениями.ОтправитьСообщение("ОбменДанными\ПрикладноеПриложение\Ответ\ОшибкаПриСозданииОбмена", ТелоСообщения, КонечнаяТочка);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка сообщений'"), 
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Процедура ОтправитьСообщениеОшибкаПриУдаленииОбмена(Код1, Код2, СтрокаОшибки, КонечнаяТочка)
	
	НачатьТранзакцию();
	Попытка
		
		ТелоСообщения = Новый Структура("Код1, Код2, СтрокаОшибки", Код1, Код2, СтрокаОшибки);
		
		ОбменСообщениями.ОтправитьСообщение("ОбменДанными\ПрикладноеПриложение\Ответ\ОшибкаПриУдаленииОбмена", ТелоСообщения, КонечнаяТочка);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Отправка сообщений'"), 
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Процедура ДобавитьОбработчикКаналаСообщений(Канал, ОбработчикКанала, Обработчики)
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Канал = Канал;
	Обработчик.Обработчик = ОбработчикКанала;
	
КонецПроцедуры
