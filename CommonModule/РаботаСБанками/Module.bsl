﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с банками".
// Процедуры и функции получения, сортировки данных классификатора
// банков РФ, запись полученных данных в справочник КлассификаторБанковРФ,
// обработка данных справочника КлассификаторБанковРФ.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

////////////////////////////////////////////////////////////////////////////////
// Работа с данными справочника КлассификаторБанковРФ

// Получает данные из справочника КлассификаторБанковРФ по значениям БИК и КоррСчета 
// 
// Параметры
//  БИК			 - Строка					   - Значение БИК
//  КоррСчет	 - Строка					   - Значение корр.счета
//  ЗаписьОБанке - СправочникСсылка или строка - результат выборки
Процедура ПолучитьДанныеКлассификатораРФ(БИК = "", КоррСчет = "", ЗаписьОБанке) Экспорт
	Если Не ПустаяСтрока(БИК) Тогда
		КлассификаторБанковРФ = Справочники.КлассификаторБанковРФ;
		ЗаписьОБанке		  = КлассификаторБанковРФ.НайтиПоКоду(БИК);
		Если ЗаписьОБанке.Пустая() Тогда
			ЗаписьОБанке = "";			
		КонецЕсли;	
	ИначеЕсли Не ПустаяСтрока(КоррСчет) Тогда
		КлассификаторБанковРФ = Справочники.КлассификаторБанковРФ;
		ЗаписьОБанке		  = КлассификаторБанковРФ.НайтиПоРеквизиту("КоррСчет", КоррСчет);
		Если ЗаписьОБанке.Пустая() Тогда
			ЗаписьОБанке = "";			
		КонецЕсли;	
	Иначе
		ЗаписьОБанке = "";
	КонецЕсли;	   
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Работа с данными сайта РБК

// Получает, сортирует, записывает данные классификатора БИК РФ с сайта РБК;
//
Процедура ЗагрузитьКлассификаторБанков() Экспорт
	
	Если ПустаяСтрока(ИмяПользователя()) Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	ПараметрыЗагрузкиКлассификатора = Новый Соответствие;
	ПараметрыЗагрузкиКлассификатора.Вставить("Загружено", 0);
	ПараметрыЗагрузкиКлассификатора.Вставить("Обновлено", 0);
	ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", "");
	
	РаботаСБанкамиВызовСервера.ПолучитьДанныеРБК(ПараметрыЗагрузкиКлассификатора);
	
	ИмяСобытия	 = НСтр("ru ='Загрузка классификатора банков. Сайт РБК'");
	
	УровеньСобытия = УровеньЖурналаРегистрации.Информация;
	
	Если ПустаяСтрока(ПараметрыЗагрузкиКлассификатора["ТекстСообщения"]) Тогда
		РаботаСБанкамиВызовСервера.ДополнитьТекстСообщения(ПараметрыЗагрузкиКлассификатора);
	Иначе
		УровеньСобытия = УровеньЖурналаРегистрации.Ошибка;
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньСобытия, , , ПараметрыЗагрузкиКлассификатора["ТекстСообщения"]);
    	
КонецПроцедуры
 
// Сортирует, записывает данные классификатора БИК РФ с сайта РБК
// 
// Параметры
//	ПараметрыЗагрузкиФайловРБК - Соответствие:
//  ПутьКФайлуБИКРБК		   - Строка - путь к файлу с данными классификатора, размещенному во временном каталоге
//  ПутьКФайлуРегионовРБК	   - Строка - путь к файлу с информацией о регионах, размещенному во временном каталоге
//	Загружено				   - Число	- Количество новых записей классификатора
//	Обновлено				   - Число	- Количество обновленных записей классификатора
//  ТекстСообщения			   - Строка - текст сообщения об ошибке
//
Процедура ЗагрузитьДанныеРБК(ПараметрыЗагрузкиФайловРБК) Экспорт
	
	СоответствиеРегионов = ПолучитьСоответствиеРегионов(ПараметрыЗагрузкиФайловРБК["ПутьКФайлуРегионовРБК"]);
	
	ТекстБИКРБК		   = Новый ЧтениеТекста(ПараметрыЗагрузкиФайловРБК["ПутьКФайлуБИКРБК"]);
	СтрокаТекстаБИКРБК = ТекстБИКРБК.ПрочитатьСтроку();
	
	ДатаЗагрузки = ТекущаяУниверсальнаяДата();
	
	ПараметрыЗагрузкиДанныхРБК = Новый Соответствие;
	ПараметрыЗагрузкиДанныхРБК.Вставить("Загружено", ПараметрыЗагрузкиФайловРБК["Загружено"]);
	ПараметрыЗагрузкиДанныхРБК.Вставить("Обновлено", ПараметрыЗагрузкиФайловРБК["Обновлено"]);
    				
	Пока СтрокаТекстаБИКРБК <> Неопределено Цикл
		
		Строка = СтрокаТекстаБИКРБК;
	
		Если ПустаяСтрока(СокрЛП(Строка)) Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураБанк  = ПолучитьСтруктуруПолейБанка(Строка, СоответствиеРегионов);
		СтрокаТекстаБИКРБК = ТекстБИКРБК.ПрочитатьСтроку();
		
		Если ПустаяСтрока(СтруктураБанк) Тогда
			Продолжить;
		КонецЕсли;
		
		ПараметрыЗагрузкиДанныхРБК.Вставить("СтруктураБанк", СтруктураБанк);
		ЗаписатьЭлементКлассификатораБанковРФ(ПараметрыЗагрузкиДанныхРБК);
		
	КонецЦикла;	
	
	ПараметрыЗагрузкиФайловРБК.Вставить("Загружено", ПараметрыЗагрузкиДанныхРБК["Загружено"]);
	ПараметрыЗагрузкиФайловРБК.Вставить("Обновлено", ПараметрыЗагрузкиДанныхРБК["Обновлено"]);
    		
КонецПроцедуры 

// Получает файл http://cbrates.rbc.ru/bnk/bnk.zip.
// Параметры:
//	ПараметрыПолученияФайловРБК - Соответствие:
//	ПутьКФайлуРБК				- Строка - путь к полученному файлу, размещенному во временном каталоге
//	ВременныйКаталог			- Строка - путь к временному каталогу
//  ТекстСообщения				- Строка - текст сообщения об ошибке
Процедура ПолучитьДанныеРБКИзИнтернета(ПараметрыПолученияФайловРБК) Экспорт

	ТекстСообщения = "";
	ПутьКФайлуРБК  = "";
	
	СерверИсточник = "cbrates.rbc.ru";
	Адрес          = "bnk";
	ФайлБИК        = "bnk.zip";
		
	ФайлРБКНаВебСервере  = "http://" + СерверИсточник + "/" + Адрес+ "/" + ФайлБИК;
	ВременныйФайлРБК	 = ПараметрыПолученияФайловРБК["ВременныйКаталог"]+ "\" + ФайлБИК;
	ПараметрыПолучения	 = Новый Структура("ПутьДляСохранения");
	ПараметрыПолучения. Вставить("ПутьДляСохранения", ВременныйФайлРБК);
	РезультатИзИнтернета = ПолучениеФайловИзИнтернета.СкачатьФайлНаСервере(ФайлРБКНаВебСервере, ПараметрыПолучения);
   		
	Если РезультатИзИнтернета.Статус Тогда
		ПараметрыПолученияФайловРБК.Вставить("ПутьКФайлуРБК", РезультатИзИнтернета.Путь);
	Иначе
		ПараметрыПолученияФайловРБК.Вставить("ТекстСообщения", РезультатИзИнтернета.СообщениеОбОшибке);
	КонецЕсли;
		  	
КонецПроцедуры	

// Определяет по коду типа города строку типа города
// Параметры:
//  КодТипа - Строка - код типа населенного пункта
// Возвращаемое значение:
//  сокращенная строка типа населенного пункта
//
Функция ОпределитьТипГородаПоКоду(КодТипа)
	
	Если КодТипа = "1" Тогда
		Возврат "Г.";       // ГОРОД
	ИначеЕсли КодТипа = "2" Тогда
		Возврат "П.";       // ПОСЕЛОК
	ИначеЕсли КодТипа = "3" Тогда
		Возврат "С.";       // СЕЛО
	ИначеЕсли КодТипа = "4" Тогда
		Возврат "ПГТ.";     // ПОСЕЛОК ГОРОДСКОГО ТИПА
	ИначеЕсли КодТипа = "5" Тогда
		Возврат "СТ-ЦА.";   // СТАНИЦА
	ИначеЕсли КодТипа = "6" Тогда
		Возврат "АУЛ.";     // АУЛ
	ИначеЕсли КодТипа = "7" Тогда
		Возврат "РП.";      // РАБОЧИЙ ПОСЕЛОК 
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

// Формирует соответствие кодов регионов и регионов.
// Параметры:
//	ПутьКФайлуРегионовРБК - Строка	   - путь к файлу с информацией о регионах, размещенному во временном каталоге 
// Возвращаемое значение:
//	СоответствиеРегионов  - Соответсвие - Код региона и регион
//	
Функция ПолучитьСоответствиеРегионов(ПутьКФайлуРегионовРБК)
	
	Разделитель					= Символы.Таб;
	СоответствиеРегионов		= Новый Соответствие;
	РегионыРБКТекстовыйДокумент = Новый ЧтениеТекста(ПутьКФайлуРегионовРБК);
	СтрокаРегионовРБК			= РегионыРБКТекстовыйДокумент.ПрочитатьСтроку();
	
	Пока СтрокаРегионовРБК <> Неопределено Цикл

		Строка			  = СтрокаРегионовРБК;
		СтрокаРегионовРБК = РегионыРБКТекстовыйДокумент.ПрочитатьСтроку();

		Если (Лев(Строка,2) = "//") или (ПустаяСтрока(Строка)) Тогда
			Продолжить;
		КонецЕсли;
		
		МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Строка, Разделитель);
		
		Если МассивПодстрок.Количество() < 2 Тогда
			Продолжить;
		КонецЕсли;	
		
		Символ1 = СокрЛП(МассивПодстрок[0]);
        Символ2 = СокрЛП(МассивПодстрок[1]);
        		 		
		// Дополним код региона до двух знаков.
		Если СтрДлина(Символ1) = 1 Тогда
			Символ1 = "0" + Символ1;
		КонецЕсли;
		
		СоответствиеРегионов.Вставить(Символ1, Символ2);
 	КонецЦикла;	
		
	Возврат СоответствиеРегионов;

КонецФункции // ПолучитьСоответствиеРегионов()

// Формирует структуру полей для банка.
// Параметры:
//	Строка  - Строка	   - Строка из текстового файла классификатора
//	Регионы - Соответствие - Код региона и регион банка
// Возвращаемое значение:
//	Банк - Структура - Реквизиты банка
//
Функция ПолучитьСтруктуруПолейБанка(Знач Строка, Регионы)
	
	Банк		= Новый Структура;
	Разделитель = Символы.Таб;
			
	Пункт		 = "";
	ТипПункта	 = "";
	Наименование = "";
	ПризнакКода	 = "";
	БИК			 = "";
	КорСчет		 = "";
	
	МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Строка, Разделитель);
	
	Если МассивПодстрок.Количество() < 7 Тогда
		Возврат "";
	КонецЕсли;	
	
	Пункт		 = СокрЛП(МассивПодстрок[1]);
	ТипПункта    = ОпределитьТипГородаПоКоду(СокрЛП(МассивПодстрок[2]));
    Наименование = СокрЛП(МассивПодстрок[3]);
	ПризнакКода  = СокрЛП(МассивПодстрок[4]);
	БИК			 = СокрЛП(МассивПодстрок[5]);
    КоррСчет	 = СокрЛП(МассивПодстрок[6]);
 		
	Если СтрДлина(БИК) <> 9 Тогда
		Возврат "";
	КонецЕсли;		
		
	Банк.Вставить("БИК",		  БИК);
	Банк.Вставить("КоррСчет",	  КоррСчет);
	Банк.Вставить("Наименование", Наименование);
	Банк.Вставить("Город",		  СокрЛП(ТипПункта + " " + Пункт));
	Банк.Вставить("Телефоны",     "");
	Банк.Вставить("Адрес",        "");
	
	КодРегиона = Сред(Банк.БИК, 3, 2);
	Регион	   = Регионы[КодРегиона];
	Если Регион <> Неопределено Тогда
		Банк.Вставить("КодРегиона", КодРегиона);
		Банк.Вставить("Регион", 	Регион);
	Иначе
		Возврат "";
	КонецЕсли;
		
	Возврат Банк;
		
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с данными диска ИТС

// Сортирует, записывает данные классификатора БИК РФ с диска ИТС
// 
// Параметры
//	ПараметрыЗагрузкиФайловИТС		 - Соответствие:
//	ПодготовкаИТСАдресДвоичныхДанных - ВременноеХранилище - Обработка подготовки данных БИК ИТС
//  ДанныеИТСАдресДвоичныхДанных	 - ВременноеХранилище - Файл данных БИК ИТС
//	Загружено						 - Число		      - Количество новых записей классификатора
//	Обновлено						 - Число			  - Количество обновленных записей классификатора
//  ТекстСообщения					 - Строка			  - текст сообщения об ошибке
//
Процедура ЗагрузитьДанныеДискИТС(ПараметрыЗагрузкиФайловИТС) Экспорт
	
	ВременныйКаталог = КаталогВременныхФайлов() + "tempBik";
	
	СоздатьКаталог(ВременныйКаталог);
	УдалитьФайлыВКаталоге(ВременныйКаталог,"*.*");
    		
	ПодготовкаИТСДвоичныеДанные = 
							ПолучитьИзВременногоХранилища(ПараметрыЗагрузкиФайловИТС["ПодготовкаИТСАдресДвоичныхДанных"]);	
	ПодготовкаИТСПуть = ВременныйКаталог + "\BIKr5v82_MA.epf";
	ПодготовкаИТСДвоичныеДанные.Записать(ПодготовкаИТСПуть);
	ОбработкаПодготовкиДанныхИТС = Новый Файл(ПодготовкаИТСПуть);
		
	ДанныеИТСДвоичныеДанные  = ПолучитьИзВременногоХранилища(ПараметрыЗагрузкиФайловИТС["ДанныеИТСАдресДвоичныхДанных"]);
	ПутьКДаннымИТС			 = ВременныйКаталог + "\Morph.dlc";
	ДанныеИТСДвоичныеДанные.Записать(ПутьКДаннымИТС);
	ДанныеИТС = Новый ТекстовыйДокумент;
	ДанныеИТС.Прочитать(ПутьКДаннымИТС);
	                   	
	ТаблицаКлассификатора = Новый ТаблицаЗначений;
	ТаблицаКлассификатора.Колонки.Добавить("БИК");
	ТаблицаКлассификатора.Колонки.Добавить("Наименование");
	ТаблицаКлассификатора.Колонки.Добавить("КоррСчет");
	ТаблицаКлассификатора.Колонки.Добавить("Город");
	ТаблицаКлассификатора.Колонки.Добавить("Адрес");
	ТаблицаКлассификатора.Колонки.Добавить("Телефоны");
	ТаблицаКлассификатора.Колонки.Добавить("КодРегиона");
	ТаблицаКлассификатора.Колонки.Добавить("Регион");
		
	ВнешняяОбработкаПодготовкиДанныхИТС = ВнешниеОбработки.Создать(ОбработкаПодготовкиДанныхИТС.ПолноеИмя);
	
	КоличествоСтрок = ДанныеИТС.КоличествоСтрок();
	
	СтрокаВерсии   = ДанныеИТС.ПолучитьСтроку(1);
	
	КоличествоЧастей = Окр(КоличествоСтрок/1000);
	СоответствиеРегионов = "";
	ТекстСообщения		 = "";
	ДатаВерсии			 = "";
	
	Для НомерЧасти = 1 По КоличествоЧастей Цикл	
		ВнешняяОбработкаПодготовкиДанныхИТС.СортироватьДанныеКлассификатора(ДанныеИТС, ТаблицаКлассификатора, 
																			СоответствиеРегионов, ДатаВерсии, 
																			НомерЧасти, ТекстСообщения);
		Если Не ПустаяСтрока(ТекстСообщения) Тогда
			Возврат;
		КонецЕсли;
		
		ПараметрыЗагрузкиДанныхИТС = Новый Соответствие;
		ПараметрыЗагрузкиДанныхИТС.Вставить("ТаблицаКлассификатора", ТаблицаКлассификатора);
		ПараметрыЗагрузкиДанныхИТС.Вставить("Загружено", ПараметрыЗагрузкиФайловИТС["Загружено"]);
		ПараметрыЗагрузкиДанныхИТС.Вставить("Обновлено", ПараметрыЗагрузкиФайловИТС["Обновлено"]);
		
		ЗаписатьДанныеКлассификатора(ПараметрыЗагрузкиДанныхИТС);
		
		ПараметрыЗагрузкиФайловИТС.Вставить("Загружено", ПараметрыЗагрузкиДанныхИТС["Загружено"]);
		ПараметрыЗагрузкиФайловИТС.Вставить("Обновлено", ПараметрыЗагрузкиДанныхИТС["Обновлено"]);
	
	КонецЦикла;
	
	УстановитьВерсиюКлассификатораБанков(ДатаВерсии);
	УдалитьФайлыВКаталоге(ВременныйКаталог,"*.*");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Запись обработанных данных

/// Записывает/перезаписывает в справочник КлассификаторБанковРФ данные банка.
// Параметры:
//	ПараметрыЗагрузкиДанных - Соответствие:
//	СтруктураБанк			- Структура или СтрокаТаблицыЗначений - Данные банка
//	Загружено				- Число								 - Количество новых записей классификатора
//	Обновлено				- Число								 - Количество обновленных записей классификатора
//
Процедура ЗаписатьЭлементКлассификатораБанковРФ(ПараметрыЗагрузкиДанных)
	
	ФлагНовый		= Ложь;
	ФлагОбновленный = Ложь;
	Регион			= "";
	
	СтруктураБанк = ПараметрыЗагрузкиДанных["СтруктураБанк"];
	Загружено	  = ПараметрыЗагрузкиДанных["Загружено"];
	Обновлено	  = ПараметрыЗагрузкиДанных["Обновлено"];
	
	Если Не ПустаяСтрока(СтруктураБанк.КодРегиона) Тогда
		ТекущийРегион = Справочники.КлассификаторБанковРФ.НайтиПоКоду(СтруктураБанк.КодРегиона);
		Если ТекущийРегион.Пустая() Тогда
			Регион = Справочники.КлассификаторБанковРФ.СоздатьГруппу();
		Иначе
			Если ТекущийРегион.ЭтоГруппа Тогда 
				Регион = ТекущийРегион.ПолучитьОбъект();
			Иначе
				Регион = Справочники.КлассификаторБанковРФ.СоздатьГруппу();
			КонецЕсли;
		КонецЕсли;
		
		Если СокрЛП(Регион.Код) <> СокрЛП(СтруктураБанк.КодРегиона) Тогда
			Регион.Код = СокрЛП(СтруктураБанк.КодРегиона);
		КонецЕсли;
		
		Если СокрЛП(Регион.Наименование) <> СокрЛП(СтруктураБанк.Регион) Тогда
			Регион.Наименование = СокрЛП(СтруктураБанк.Регион);
		КонецЕсли;
		
		Если Регион.Модифицированность() Тогда
			Регион.Записать();
		КонецЕсли;
    КонецЕсли;	
	
	ЗаписываемыйЭлементСправочникаКлассификаторБанковРФ = Справочники.КлассификаторБанковРФ.НайтиПоКоду(СтруктураБанк.БИК);
		        		
	Если ЗаписываемыйЭлементСправочникаКлассификаторБанковРФ.Пустая() Тогда
		КлассификаторБанковОбъект = Справочники.КлассификаторБанковРФ.СоздатьЭлемент();
		ФлагНовый				  = Истина;
	Иначе	
		КлассификаторБанковОбъект = ЗаписываемыйЭлементСправочникаКлассификаторБанковРФ.ПолучитьОбъект();
	КонецЕсли;	
	
	Если КлассификаторБанковОбъект.Код <> СтруктураБанк.БИК Тогда
		КлассификаторБанковОбъект.Код = СтруктураБанк.БИК;
	КонецЕсли;
    	
	Если КлассификаторБанковОбъект.Наименование <> СтруктураБанк.Наименование Тогда
		Если Не ПустаяСтрока(СтруктураБанк.Наименование) Тогда
        	КлассификаторБанковОбъект.Наименование = СтруктураБанк.Наименование;
		КонецЕсли;	
	КонецЕсли;
	
	Если КлассификаторБанковОбъект.КоррСчет <> СтруктураБанк.КоррСчет Тогда
		Если Не ПустаяСтрока(СтруктураБанк.КоррСчет) Тогда
			КлассификаторБанковОбъект.КоррСчет	= СтруктураБанк.КоррСчет;
		КонецЕсли;	
	КонецЕсли;
	
	Если КлассификаторБанковОбъект.Город <> СтруктураБанк.Город Тогда
		Если Не ПустаяСтрока(СтруктураБанк.Город) Тогда
			КлассификаторБанковОбъект.Город = СтруктураБанк.Город;
		КонецЕсли;	
	КонецЕсли;
			
	Если КлассификаторБанковОбъект.Адрес <> СтруктураБанк.Адрес Тогда
		Если Не ПустаяСтрока(СтруктураБанк.Адрес) Тогда
			КлассификаторБанковОбъект.Адрес = СтруктураБанк.Адрес;
		КонецЕсли;	
	КонецЕсли;
	
	Если КлассификаторБанковОбъект.Телефоны <> СтруктураБанк.Телефоны Тогда
		Если Не ПустаяСтрока(СтруктураБанк.Телефоны) Тогда
			КлассификаторБанковОбъект.Телефоны = СтруктураБанк.Телефоны;
		КонецЕсли;	
	КонецЕсли;
	
	Если Не ПустаяСтрока(Регион) Тогда
		Если КлассификаторБанковОбъект.Родитель <> Регион.Ссылка Тогда
			КлассификаторБанковОбъект.Родитель = Регион.Ссылка;
		КонецЕсли;	
	КонецЕсли;	
    			
	Если КлассификаторБанковОбъект.Модифицированность() Тогда
		ФлагОбновленный		  = Истина;
		КлассификаторБанковОбъект.Записать();
	КонецЕсли;
	
	Если ФлагНовый Тогда
		Загружено = Загружено + 1;
	ИначеЕсли ФлагОбновленный Тогда
		Обновлено = Обновлено + 1;
	КонецЕсли;
	
	ПараметрыЗагрузкиДанных.Вставить("Загружено", Загружено);
	ПараметрыЗагрузкиДанных.Вставить("Обновлено", Обновлено);
	
КонецПроцедуры

// Записывает/перезаписывает в справочник КлассификаторБанковРФ данные банков.
// Параметры:
//	ПараметрыЗагрузкиДанныхИТС - Соответствие:
//	ТаблицаКлассификатора	   - ТаблицаЗначений - Данные банков
//	Загружено				   - Число			 - Количество новых записей классификатора
//	Обновлено				   - Число			 - Количество обновленных записей классификатора
//
Процедура ЗаписатьДанныеКлассификатора(ПараметрыЗагрузкиДанныхИТС)
	
	ТаблицаБанков = ПараметрыЗагрузкиДанныхИТС["ТаблицаКлассификатора"];
	
	ПараметрыЗагрузкиДанных = Новый Соответствие;
	ПараметрыЗагрузкиДанных.Вставить("Загружено", ПараметрыЗагрузкиДанныхИТС["Загружено"]);
	ПараметрыЗагрузкиДанных.Вставить("Обновлено", ПараметрыЗагрузкиДанныхИТС["Обновлено"]);
    
	Для СчетчикБанков = 1 по ТаблицаБанков.Количество() Цикл
		
		СтрокаТаблицыБанков = ТаблицаБанков.Получить(СчетчикБанков - 1);
		
		ПараметрыЗагрузкиДанных.Вставить("СтруктураБанк", СтрокаТаблицыБанков);
		ЗаписатьЭлементКлассификатораБанковРФ(ПараметрыЗагрузкиДанных);
				        				
	КонецЦикла;	
	
	ПараметрыЗагрузкиДанныхИТС.Вставить("Загружено", ПараметрыЗагрузкиДанных["Загружено"]);
	ПараметрыЗагрузкиДанныхИТС.Вставить("Обновлено", ПараметрыЗагрузкиДанных["Обновлено"]);
    				
КонецПроцедуры

// Устанавливает значение даты загрузки данных классификатора
// 
// Параметры
//  ДатаВерсии - ДатаВремя - Дата загрузки данных классификатора
Процедура УстановитьВерсиюКлассификатораБанков(ДатаВерсии = "") Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(ДатаВерсии) <> Тип("Дата") Тогда
		Константы.ВерсияКлассификатораБанковРФ.Установить(ТекущаяУниверсальнаяДата());
	Иначе
		Константы.ВерсияКлассификатораБанковРФ.Установить(ДатаВерсии);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры		

////////////////////////////////////////////////////////////////////////////////
// Технологические процедуры и фунцкии

// Проверяет существование каталога 
// Параметры:
//  ИмяКаталога - Строка - путь к каталогу
// Возвращаемое значение:
//  булево 
//
Функция ПроверитьСуществованиеКаталога(ИмяКаталога) 
    КаталогНаДиске = Новый Файл(ИмяКаталога);
	Если КаталогНаДиске.Существует() Тогда
		Возврат КаталогНаДиске.ЭтоКаталог();
	Иначе	
		Возврат Ложь;
	КонецЕсли;	
КонецФункции

// Удаляет файлы в каталоге 
// Параметры:
//  ИмяКаталога		- Строка - путь к каталогу
//  МаскаИмениФайла - Строка - маска имени удаляемых файлов
//
Процедура УдалитьФайлыВКаталоге(ИмяКаталога, МаскаИмениФайла = "*.*") Экспорт
	Если ПроверитьСуществованиеКаталога(ИмяКаталога) Тогда
		УдаляемыеФайлы = НайтиФайлы(ИмяКаталога, МаскаИмениФайла);
		Для СчетчикФайлов = 1 По УдаляемыеФайлы.Количество() Цикл
			УдаляемыйОбъект = УдаляемыеФайлы[СчетчикФайлов-1];
			Если УдаляемыйОбъект.ЭтоФайл() Тогда
				УдаляемыйОбъект.УстановитьТолькоЧтение(Ложь);				
			Иначе	
				УдалитьФайлыВКаталоге(УдаляемыйОбъект.ПолноеИмя, МаскаИмениФайла);
			КонецЕсли;	
		КонецЦикла;	
		УдалитьФайлы(ИмяКаталога, МаскаИмениФайла);
	КонецЕсли;	
КонецПроцедуры	


  
