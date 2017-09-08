﻿// Устанавливает компоненту сканирования
Процедура УстановитьКомпоненту() Экспорт

	Если КомпонентаTwain = Неопределено Тогда
		КодВозврата = ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаTWAIN", "twain", ТипВнешнейКомпоненты.Native);
		
		Если КодВозврата Тогда
			Состояние(НСтр("ru = 'Компонента сканирования уже установлена.'"));
		Иначе
			УстановитьВнешнююКомпоненту("ОбщийМакет.КомпонентаTWAIN");
			КодВозврата = ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаTWAIN", "twain", ТипВнешнейКомпоненты.Native);
			
			Если КодВозврата Тогда
				РаботаСФайламиВызовСервера.ОчиститьНастройкиФормНовогоФайла();
				Оповестить("КомпонентаСканированияУстановлена");
			КонецЕсли;
		КонецЕсли;

		КомпонентаTwain = Новый("AddIn.twain.AddInNativeExtension");	
	Иначе
		Состояние(НСтр("ru = 'Компонента сканирования уже установлена.'"));
	КонецЕсли;
	
КонецПроцедуры

// Проинициализировать компоненту сканирования
Функция ПроинициализироватьКомпоненту() Экспорт
	Если КомпонентаTwain = Неопределено Тогда
		КодВозврата = ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаTWAIN", "twain", ТипВнешнейКомпоненты.Native);
		
		Если Не КодВозврата Тогда
			Возврат Ложь;
		КонецЕсли;

		КомпонентаTwain = Новый("AddIn.twain.AddInNativeExtension");	
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

// Вернет версию компоненты сканирования
Функция ВерсияКомпонентыСканирования() Экспорт

	Если Не ПроинициализироватьКомпоненту() Тогда
		Возврат НСтр("ru= 'Компонента сканирования не установлена'");
	КонецЕсли;
	
	Возврат КомпонентаTwain.Версия();
КонецФункции // ВерсияКомпонентыСканирования()

// Вернет массив строк - устройства TWAIN
Функция ПолучитьУстройства() Экспорт
	Массив = Новый Массив;
	
	Если Не ПроинициализироватьКомпоненту() Тогда
		Возврат Массив;
	КонецЕсли;
	
	СтрокаУстройств = КомпонентаTwain.ПолучитьУстройства();
	
	Для Индекс = 1 По СтрЧислоСтрок(СтрокаУстройств) Цикл
		Строка = СтрПолучитьСтроку(СтрокаУстройств, Индекс); 		
		Массив.Добавить(Строка);
	КонецЦикла;	
	
	Возврат Массив;
КонецФункции // ПолучитьУстройства()



// Вызвать диалог сканирования и показать диалог просмотра картинки
Процедура СканироватьИПоказатьДиалогПросмотра(ВладелецФайла, УникальныйИдентификатор, ЭтаФорма,
	НеОткрыватьКарточкуПослеСозданияИзФайла = Неопределено) Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	
	ПараметрыОткрытия = Новый Структура("ВладелецФайла, НеОткрыватьКарточкуПослеСозданияИзФайла, ИдентификаторКлиента", 
		ВладелецФайла, НеОткрыватьКарточкуПослеСозданияИзФайла, ИдентификаторКлиента);
	ОткрытьФормуМодально("Справочник.Файлы.Форма.РезультатСканирования", ПараметрыОткрытия);
	
КонецПроцедуры

// Вернет Истина, если доступна команда Сканировать - установлена компонента сканирования и есть хоть один сканер
Функция ДоступнаКомандаСканировать() Экспорт

	Если Не ПроинициализироватьКомпоненту() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если КомпонентаTwain.ЕстьУстройства() тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции // ДоступнаКомандаСканировать()


// Получает настройку сканера по имени
//
// Параметры
//  ИмяУстройства  - Строка - Имя сканера
//
//  ИмяНастройки  - Строка - имя настройки, например "XRESOLUTION" или "PIXELTYPE" или "ROTATION" или "SUPPORTEDSIZES"	
//
//
// Возвращаемое значение:
//   Число   - значение настройки сканера
//
Функция ПолучитьНастройку(ИмяУстройства, ИмяНастройки) Экспорт
	
	Попытка
		Возврат КомпонентаTwain.ПолучитьНастройку(ИмяУстройства, ИмяНастройки);
	Исключение
		Возврат -1;
	КонецПопытки;
	
КонецФункции // ПолучитьНастройку()

// Сохраняет в настройках цветность и разрешение
Процедура СохранитьВНастройкахПараметрыСканера(Разрешение, Цветность, Поворот, РазмерБумаги) Экспорт
	
	МассивСтруктур = Новый Массив;
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиСканирования/Разрешение");
	Элемент.Вставить("Настройка", ИдентификаторКлиента);
	Элемент.Вставить("Значение", Разрешение);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиСканирования/Цветность");
	Элемент.Вставить("Настройка", ИдентификаторКлиента);
	Элемент.Вставить("Значение", Цветность);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиСканирования/Поворот");
	Элемент.Вставить("Настройка", ИдентификаторКлиента);
	Элемент.Вставить("Значение", Поворот);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "НастройкиСканирования/РазмерБумаги");
	Элемент.Вставить("Настройка", ИдентификаторКлиента);
	Элемент.Вставить("Значение", РазмерБумаги);
	МассивСтруктур.Добавить(Элемент);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранитьМассив(МассивСтруктур);
	
КонецПроцедуры	