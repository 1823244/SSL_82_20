﻿// Покажет напоминание о порядке работы с файлом в веб-клиенте
// если установлена настройка "Показывать подсказки при редактировании файлов"
//
Процедура ПоказатьНапоминаниеПриРедактировании() Экспорт
	
	Если ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ПоказыватьПодсказкиПриРедактированииФайлов = Истина Тогда
		
		РасширениеПодключено = ПодключитьРасширениеРаботыСФайлами();
		Если НЕ РасширениеПодключено Тогда
			Форма = ФайловыеФункцииКлиентПовтИсп.ПолучитьФормуНапоминанияПриРедактировании();
			БольшеНеПоказывать = Форма.ОткрытьМодально();
			
			Если БольшеНеПоказывать = Истина Тогда
				ПоказыватьПодсказкиПриРедактированииФайлов = Ложь;
				ОбщегоНазначения.ХранилищеОбщихНастроекСохранитьИОбновитьПовторноИспользуемыеЗначения("НастройкиПрограммы", "ПоказыватьПодсказкиПриРедактированииФайлов", ПоказыватьПодсказкиПриРедактированииФайлов);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Функция возвращает каталог "Мои Документы" + имя текущего пользователя или ранее использованную папку для выгрузки
//
Функция КаталогВыгрузки() Экспорт
	
	Путь = "";
	
#Если Не ВебКлиент Тогда
	
	Путь = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ИмяПапкиВыгрузки", "ИмяПапкиВыгрузки");
	
	Если Путь = Неопределено Тогда
		Если НЕ СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ЭтоБазоваяВерсияКонфигурации Тогда
			Оболочка = Новый COMОбъект("MSScriptControl.ScriptControl");
			Оболочка.Language = "vbscript";
			Оболочка.AddCode("
				|Function SpecialFoldersName(Name)
				|set Shell=CreateObject(""WScript.Shell"")
				|SpecialFoldersName=Shell.SpecialFolders(Name)
				|End Function");
			Путь = НормализоватьКаталог(Оболочка.Run("SpecialFoldersName", "MyDocuments"));
			ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ИмяПапкиВыгрузки", "ИмяПапкиВыгрузки", Путь);
		КонецЕсли;
	КонецЕсли;
	
#КонецЕсли
	
	Возврат Путь;
	
КонецФункции

// Показывает пользователю диалог выбора файлов и возвращает
// массив - выбранные для импорта файлы
//
Функция ПолучитьСписокИмпортируемыхФайлов() Экспорт
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	Фильтр = НСтр("ru = 'Все файлы(*.*)|*.*'");
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Истина;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите файлы'");
	
	МассивИменФайлов = Новый Массив;
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		
		МассивФайлов = ДиалогОткрытияФайла.ВыбранныеФайлы;
		
		Для Каждого ИмяФайла Из МассивФайлов Цикл
			МассивИменФайлов.Добавить(ИмяФайла);
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат МассивИменФайлов;
	
КонецФункции

// Функция добавляет концевой слэш к имени каталога, если это надо
// а также удаляет все запрещенные символы из имени каталога
// кроме того, "/" заменяется на "\"
//
Функция НормализоватьКаталог(ИмяКаталога) Экспорт
	Результат = СокрЛП(ИмяКаталога);
	
	// Запомним наличие "Диск:" в начале пути и потом вернем ":" после имени диска
	СтрДиск = "";
	Если Сред(Результат, 2, 1) = ":" Тогда
		СтрДиск = Сред(Результат, 1, 2);
		Результат = Сред(Результат, 3);
	Иначе
		
		// А здесь проверим, что у нас не UNC-путь (т.е. путь начинающийся на "\\")
		Если Сред(Результат, 2, 2) = "\\" Тогда
			СтрДиск = Сред(Результат, 1, 2);
			Результат = Сред(Результат, 3);
		КонецЕсли;
	КонецЕсли;
	
	// Делаем слэши в Windows-стиле
	Результат = СтрЗаменить(Результат, "/", "\");
	
	// Добавляем финишный слэш
	Результат = СокрЛП(Результат);
	Если Прав(Результат,1) <> "\" Тогда
		Результат = Результат + "\";
	КонецЕсли;
	
	// Заменим все двойные слэши на одинарные и  получим полный путь
	Результат = СтрДиск + СтрЗаменить(Результат, "\\", "\");
	
	Возврат Результат;
КонецФункции

// Процедура предназначена для проверки имени файла на наличие некорректных символов
// Параметры:
//  СтрИмяФайла  - Строка
//                 проверяемое имя файла
//  ФлУдалятьНекорректные - Булево
//                 удалять или нет некорректные символы из переданной строки
Процедура КорректноеИмяФайла(ИмяФайла, ФлУдалятьНекорректные = Ложь) Экспорт
	
	// Перечень запрещенных символов взят отсюда: http://support.microsoft.com/kb/100108/ru
	//  при этом были объединены запрещенные символы для файловых систем FAT и NTFS
	
	СтрИсключения = ОбщегоНазначенияКлиентСервер.ПолучитьНедопустимыеСимволыВИмениФайла();
	
	ТекстОшибки =
	СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	  НСтр("ru = 'В имени файла не должно быть следующих символов: %1'"), СтрИсключения);
	
	Результат = Истина;
	
	МассивНайденныхНедопустимыхСимволов = ОбщегоНазначенияКлиентСервер.НайтиНедопустимыеСимволыВИмениФайла(ИмяФайла);
	Если МассивНайденныхНедопустимыхСимволов.Количество() <> 0 Тогда
		
		Результат = Ложь;
		
		Если ФлУдалятьНекорректные Тогда
			ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайла, "");
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не Результат Тогда
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры // КорректноеИмяФайла()

// Рекурсивно обойти каталоги и посчитать количество файлов и их суммарный размер
//
Процедура ОбходФайловРазмер(Путь, МассивФайлов, РазмерСуммарный, КоличествоСуммарное) Экспорт
	
	Для Каждого ВыбранныйФайл Из МассивФайлов Цикл
		
		Если ВыбранныйФайл.ЭтоКаталог() Тогда
			НовыйПуть = Строка(Путь);
			НовыйПуть = НовыйПуть + ФайловыеФункцииКлиентСервер.ПолучитьСлеш(ОбщегоНазначенияКлиентПовтИсп.ТипПлатформыКлиента());
			НовыйПуть = НовыйПуть + Строка(ВыбранныйФайл.Имя);
			МассивФайловВКаталоге = НайтиФайлы(НовыйПуть, "*.*");
			
			Если МассивФайловВКаталоге.Количество() <> 0 Тогда
				ОбходФайловРазмер(НовыйПуть, МассивФайловВКаталоге, РазмерСуммарный, КоличествоСуммарное);
			КонецЕсли;
		
			Продолжить;
		КонецЕсли;
		
		РазмерСуммарный = РазмерСуммарный + ВыбранныйФайл.Размер();
		КоличествоСуммарное = КоличествоСуммарное + 1;
		
	КонецЦикла;
	
КонецПроцедуры

// Получить полный путь к файлу
Функция ПолучитьПолныйПутьКФайлуВРабочемКаталоге(ДанныеФайла) Экспорт
	Возврат ДанныеФайла.ИмяФайлаСПутемВРабочемКаталоге;
КонецФункции

// Функция получает путь к каталогу вида "C:\Documents and Settings\ИМЯ ПОЛЬЗОВАТЕЛЯ\Application Data\1C\ФайлыА8\"
//
Функция ПолучитьПутьККаталогуДанныхПользователя() Экспорт
	
	ИмяКаталога = "";
	
#Если Не ВебКлиент Тогда
	
	Если НЕ СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ЭтоБазоваяВерсияКонфигурации Тогда
		Оболочка = Новый COMОбъект("WScript.Shell");
		Путь = Оболочка.ExpandEnvironmentStrings("%APPDATA%");
		Путь = Путь + "\1C\Файлы\";
		
		ПараметрыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента();
		
		Путь = Путь + ПараметрыКлиента.ИмяКонфигурации
			+ ФайловыеФункцииКлиентСервер.ПолучитьСлеш(ОбщегоНазначенияКлиентПовтИсп.ТипПлатформыКлиента());
		
		ИмяПользователя = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ТекущийПользователь;
		ИмяКаталога = Путь + ИмяПользователя;
		ИмяКаталога = СтрЗаменить(ИмяКаталога, "<", " ");
		ИмяКаталога = СтрЗаменить(ИмяКаталога, ">", " ");
		ИмяКаталога = СокрЛП(ИмяКаталога);
		ИмяКаталога = ИмяКаталога + ФайловыеФункцииКлиентСервер.ПолучитьСлеш(ОбщегоНазначенияКлиентПовтИсп.ТипПлатформыКлиента());
	КонецЕсли;
	
#Иначе // ВебКлиент
	
	РасширениеПодключено = ПодключитьРасширениеРаботыСФайлами();
	
	Если РасширениеПодключено Тогда
		
		Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
		ДиалогОткрытияФайла.ПолноеИмяФайла = "";
		ДиалогОткрытияФайла.Каталог = "";
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите путь к локальному кэшу файлов'");
		Если ДиалогОткрытияФайла.Выбрать() Тогда
			ИмяКаталога = ДиалогОткрытияФайла.Каталог;
			ИмяКаталога = ИмяКаталога + ФайловыеФункцииКлиентСервер.ПолучитьСлеш(ОбщегоНазначенияКлиентПовтИсп.ТипПлатформыКлиента());
		КонецЕсли;
		
	КонецЕсли;
	
#КонецЕсли
	
	Возврат ИмяКаталога;
	
КонецФункции

// открыть Windows проводник, выбрав в нем указанный файл
//
Функция ОткрытьПроводникСФайлом(Знач ПолноеИмяФайла) Экспорт
	
#Если НЕ ВебКлиент Тогда
	ФайлНаДиске = Новый Файл(ПолноеИмяФайла);
	
	Если ФайлНаДиске.Существует() Тогда
		
		Если Лев(ПолноеИмяФайла, 0) <> """" Тогда
			ПолноеИмяФайла = """" + ПолноеИмяФайла + """";
		КонецЕсли;
		
		ЗапуститьПриложение("explorer.exe /select, " + ПолноеИмяФайла);
		
		Возврат Истина;
		
	КонецЕсли;
#КонецЕсли
	
	Возврат Ложь;
	
КонецФункции

// Проинициализировать параметр сеанса ПутьКРабочемуКаталогуПользователя, проверив корректность пути, и откорректировав если нужно
// 
Процедура ПроинициализироватьПутьКРабочемуКаталогу() Экспорт
	
	ИмяКаталога = ФайловыеФункцииКлиентПовтИсп.ПолучитьРабочийКаталогПользователя();
	
	// уже проинициализировано
	Если ИмяКаталога <> Неопределено И НЕ ПустаяСтрока(ИмяКаталога) И ПроверкаДоступаКРабочемуКаталогуВыполнена = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяКаталога = Неопределено Тогда
		ИмяКаталога = ПолучитьПутьККаталогуДанныхПользователя();
		Если Не ПустаяСтрока(ИмяКаталога) Тогда
			СохранитьПутьККаталогуВНастройках(ИмяКаталога);
		Иначе
			ПроверкаДоступаКРабочемуКаталогуВыполнена = Истина;
			Возврат; //  веб клиент без расширения работы с файлами
		КонецЕсли;
	КонецЕсли;
	
#Если Не ВебКлиент Тогда
	// Создать каталог для файлов
	Попытка
		СоздатьКаталог(ИмяКаталога);
		ИмяКаталогаТестовое = ИмяКаталога + "ПроверкаДоступа\";
		СоздатьКаталог(ИмяКаталогаТестовое);
		УдалитьФайлы(ИмяКаталогаТестовое);
	Исключение
		// нет прав на создание каталога, или такой путь отсутствует - сбрасываем в настройки по умолчанию
		ИмяКаталога = ПолучитьПутьККаталогуДанныхПользователя();
		СохранитьПутьККаталогуВНастройках(ИмяКаталога);
	КонецПопытки;
#КонецЕсли
	
	ПроверкаДоступаКРабочемуКаталогуВыполнена = Истина;
	
КонецПроцедуры

// Сохраняет путь к рабочему каталогу в настройках
//
Процедура СохранитьПутьККаталогуВНастройках(ИмяКаталога)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранитьИОбновитьПовторноИспользуемыеЗначения("ЛокальныйКэшФайлов", "ПутьКЛокальномуКэшуФайлов", ИмяКаталога);
	
КонецПроцедуры

#Если НЕ ВебКлиент Тогда
// Извлекает текст из файла на диске на клиенте и помещает результат на сервер
//
Процедура ИзвлечьТекстВерсии(ФайлИлиВерсияФайла, АдресФайла, Расширение, УникальныйИдентификатор,
	Кодировка = Неопределено) Экспорт
	
	ИмяФайлаСПутем = ПолучитьИмяВременногоФайла(Расширение);
	
	Если Не ПолучитьФайл(АдресФайла, ИмяФайлаСПутем, Ложь) Тогда
		Возврат;
	КонецЕсли;
	
	// для варианта с хранением файлов на диске (на сервере) удаляем Файл из временного хранилища после получения
	Если ЭтоАдресВременногоХранилища(АдресФайла) Тогда
		УдалитьИзВременногоХранилища(АдресФайла);
	КонецЕсли;
	
	РезультатИзвлечения = "НеИзвлечен";
	АдресВременногоХранилищаТекста = "";
	
	Текст = "";
	Если ИмяФайлаСПутем <> "" Тогда
		
		// Извлекаем текст из файла
		Отказ = Ложь;
		Текст = ФайловыеФункцииКлиентСервер.ИзвлечьТекст(ИмяФайлаСПутем, Отказ, Кодировка);
		
		Если Отказ = Ложь Тогда
			РезультатИзвлечения = "Извлечен";
			
			Если Не ПустаяСтрока(Текст) Тогда
				ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
				ТекстовыйФайл = Новый ЗаписьТекста(ИмяВременногоФайла, КодировкаТекста.UTF8);
				ТекстовыйФайл.Записать(Текст);
				ТекстовыйФайл.Закрыть();
				
				ПоместитьФайл(АдресВременногоХранилищаТекста, ИмяВременногоФайла, , Ложь, УникальныйИдентификатор);
				УдалитьФайлы(ИмяВременногоФайла);
			КонецЕсли;
		Иначе	
			// Ничего не пишем - это нормальная ситуация - когда Текст некому извлечь
			РезультатИзвлечения = "ИзвлечьНеУдалось";
		КонецЕсли;
		
	КонецЕсли;
	
	УдалитьФайлы(ИмяФайлаСПутем);
	
	ФайловыеФункции.ЗаписатьРезультатИзвлеченияТекста(ФайлИлиВерсияФайла, РезультатИзвлечения, АдресВременногоХранилищаТекста);
	
КонецПроцедуры
#КонецЕсли
