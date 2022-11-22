//
//  CategoriesStorage.swift
//  emassi_IOS
//
//  Created by Алексей Рябин on 17.10.2022.
//

import Foundation
protocol CategoriesStorageProtocol{
    func getAllCategories(completion: @escaping ([any PerformersCategory]) -> Void)
    func getAllSuperCategories(completion: @escaping ([PerformersMainCategory]) -> Void)
    func getAllSubCategories(completion: @escaping ([any PerformersCategory]) -> Void)
    func getSuperCategoryById(categoryId: String, completion: @escaping (PerformersMainCategory?) -> Void)
    func getSuperCategoryForSubCategory(categoryId: String, completion: @escaping (PerformersMainCategory?) -> Void)
    func getCategoryInfo(categoryId: String, completion: @escaping ((any PerformersCategory)?) -> Void)
}

class CategoryStorage: CategoriesStorageProtocol{
    func getAllCategories(completion: @escaping ([any PerformersCategory]) -> Void) {
        var catogories: [any PerformersCategory] = []
        self.categories.forEach { pair in
            catogories.append(pair.value)
            catogories.append(contentsOf: pair.value.subCategories)
        }
        completion(catogories)
    }
    
    func getAllSubCategories(completion: @escaping ([any PerformersCategory]) -> Void) {
        var categories: [any PerformersCategory] = []
        self.categories.forEach({
            categories.append(contentsOf: $0.value.subCategories)
        })
    }
    
    func getAllSuperCategories(completion: @escaping ([PerformersMainCategory]) -> Void) {
        completion(categories.values.sorted(by: {
            $0.value < $1.value
        }))
    }
    
    func getSuperCategoryById(categoryId: String, completion: @escaping (PerformersMainCategory?) -> Void) {
        completion(categories[categoryId])
    }
    
    func getSuperCategoryForSubCategory(categoryId: String, completion: @escaping (PerformersMainCategory?) -> Void) {
        let superCategory = categories.first { pair in
            pair.value.subCategories.contains(where: {
                $0.value == categoryId
            })
        }
        completion(superCategory?.value)
    }
    
    func getCategoryInfo(categoryId: String, completion: @escaping ((any PerformersCategory)?) -> Void) {
        var searchCategory: (any PerformersCategory)? = nil
        defer{
            completion(searchCategory)
        }
        if let mainCategory = categories[categoryId]{
            searchCategory = mainCategory
        } else {
            categories.forEach { pair in
                let subCategory = pair.value.subCategories.first(where: {
                    $0.value == categoryId
                })
                if subCategory != nil {
                    searchCategory = subCategory
                    return
                }
            }
        }
        
    }
    
    var categories: [String : PerformersMainCategory] = [:]
    
    init(){
        let categoriesArray = [
            PerformersMainCategory(name: "Перевозки и курьерские услуги", value: "0100", imageAddress: "categoryDelivery",subCategories: [
                .init(name: "Перевозка вещей во время переезда", value: "0101"),
                .init(name: "Грузоперевозки", value: "0102"),
                .init(name: "Пассажирские перевозки", value: "0103"),
                .init(name: "Услуги грузчиков", value: "0104"),
                .init(name: "Манипуляторы и подъемные краны", value: "0105"),
                .init(name: "Услуги пешего курьера", value: "0106"),
                .init(name: "Услуги курьера на авто", value: "0107"),
                .init(name: "Доставка товара из интернет-магазина", value: "0108"),
                .init(name: "Доставка цветов", value: "0109"),
                .init(name: "Доставка продуктов и еды из ресторанов", value: "0110"),
                .init(name: "Доставка лекарств", value: "0111"),
                .init(name: "Курьерская доставка", value: "0112"),
                .init(name: "Аренда склада", value: "0113"),
                .init(name: "Услуги такси", value: "0114"),
                .init(name: "Услуга трезвый водитель", value: "0115"),
                .init(name: "Международные или междугородние перевозки", value: "0116"),
                .init(name: "Эвакуация транспорта", value: "0117"),
                .init(name: "Перевозки и курьерские услуги - Другое", value: "0118")
            ]),
            
            PerformersMainCategory(name: "Строительство и ремонтные работы", value: "0200", imageAddress: "categoryBuilders",subCategories: [
                .init(name: "Услуги дизайнера", value: "0201"),
                .init(name: "Ремонт под ключ", value: "0202"),
                .init(name: "Проектирование и услуги архитектора", value: "0203"),
                .init(name: "Услуги сантехника", value: "0204"),
                .init(name: "Электромонтажные работы", value: "0205"),
                .init(name: "Отделка помещений", value: "0206"),
                .init(name: "Потолочные работы", value: "0207"),
                .init(name: "Напольные работы", value: "0208"),
                .init(name: "Изготовление и монтаж лестниц", value: "0209"),
                .init(name: "Укладка плитки", value: "0210"),
                .init(name: "Установка и ремонт дверей и замков", value: "0211"),
                .init(name: "Установка и ремонт окон", value: "0212"),
                .init(name: "Кровельные работы", value: "0213"),
                .init(name: "Фасадные работы", value: "0214"),
                .init(name: "Ландшафтные работы и дизайн", value: "0215"),
                .init(name: "Сварочные работы", value: "0216"),
                .init(name: "Установка отопления и систем вентиляции", value: "0217"),
                .init(name: "Установка кондиционеров", value: "0218"),
                .init(name: "Установка бытовой техники", value: "0219"),
                .init(name: "Строительно-монтажные работы", value: "0220"),
                .init(name: "Охранные системы и видеонаблюдение", value: "0221"),
                .init(name: "Умный дом", value: "0222"),
                .init(name: "Изоляционные работы", value: "0223"),
                .init(name: "Малярные работы", value: "0224"),
                .init(name: "Изготовление, сборка и ремонт мебели", value: "0225"),
                .init(name: "Уборка и вывоз строительного мусора", value: "0226"),
                .init(name: "Мастер на час", value: "0227"),
                .init(name: "Строительство и ремонтные работы - Другое", value: "0228"),
            ]),
            PerformersMainCategory(name: "Быт и клининговые услуги", value: "0300", imageAddress: "categoryCleaning",subCategories: [
                .init(name: "Ремонт бытовой техники", value: "0301"),
                .init(name: "Ремонт цифровой техники", value: "0302"),
                .init(name: "Ремонт садовой техники", value: "0303"),
                .init(name: "Уборка помещений", value: "0304"),
                .init(name: "Генеральная уборка", value: "0305"),
                .init(name: "Уборка прилегающей территории", value: "0306"),
                .init(name: "Вынос мусора", value: "0307"),
                .init(name: "Услуги химчистки", value: "0308"),
                .init(name: "Мойка окон", value: "0309"),
                .init(name: "Мойка фасадов", value: "0310"),
                .init(name: "Дезинфекция помещений", value: "0311"),
                .init(name: "Дезинсекция", value: "0312"),
                .init(name: "Стирка и глажка белья", value: "0313"),
                .init(name: "Услуги сиделки", value: "0314"),
                .init(name: "Услуги няни", value: "0315"),
                .init(name: "Работы в саду, огороде", value: "0316"),
                .init(name: "Ремонт обуви", value: "0317"),
                .init(name: "Ремонт часов", value: "0318"),
                .init(name: "Ремонт ювелирных изделий", value: "0319"),
                .init(name: "Услуги ателье", value: "0320"),
                .init(name: "Уход за животными", value: "0321"),
                .init(name: "Помощь ветеринара", value: "0322"),
                .init(name: "Быт и клининговые услуги - Другое", value: "0323"),
            ]),
            PerformersMainCategory(name: "Перевод и копирайтинг", value: "0400", imageAddress: "categoryTranslate",subCategories: [
                .init(name: "Копирайтинг", value: "0401"),
                .init(name: "Рерайтинг", value: "0402"),
                .init(name: "Сбор и обработка информации", value: "0403"),
                .init(name: "Набор текста", value: "0404"),
                .init(name: "Разработка презентаций", value: "0405"),
                .init(name: "Перевод текста", value: "0406"),
                .init(name: "Перевод документов и нотариальное заверение", value: "0407"),
                .init(name: "Перевод аудио и видеозаписей", value: "0408"),
                .init(name: "Услуги синхронного переводчика", value: "0409"),
                .init(name: "Апостиль и легализация", value: "0410"),
                .init(name: "Перевод и копирайтинг - Другое", value: "0411"),
            ]),
            PerformersMainCategory(name: "Web - разработка и IT услуги",value: "0500", imageAddress: "categoryIT", subCategories: [
                .init(name: "Разработка и поддержка ПО", value: "0501"),
                .init(name: "Разработка и поддержка приложений для iOS", value: "0502"),
                .init(name: "Разработка и поддержка приложений для Android", value: "0503"),
                .init(name: "Создание сайта под ключ", value: "0504"),
                .init(name: "Дизайн сайта и приложений", value: "0505"),
                .init(name: "Верстка", value: "0506"),
                .init(name: "Поддержка и доработка сайтов", value: "0507"),
                .init(name: "Тестирование ПО", value: "0508"),
                .init(name: "Администрирование серверов", value: "0509"),
                .init(name: "Разработка и внедрение CRM систем", value: "0510"),
                .init(name: "Внедрение 1С", value: "0511"),
                .init(name: "Web - разработка и IT услуги - Другое", value: "0512"),
            ]),
            PerformersMainCategory(name: "Дизайн",value: "0600", imageAddress: "categoryDesign",subCategories: [
                .init(name: "Дизайн интерьера", value: "0601"),
                .init(name: "Архитектурный дизайн", value: "0602"),
                .init(name: "Ландшафтный дизайн", value: "0603"),
                .init(name: "Дизайн сайта, приложений, иконок", value: "0604"),
                .init(name: "Дизайн логотипов, визиток", value: "0605"),
                .init(name: "Создание фирменного стиля", value: "0606"),
                .init(name: "Полиграфический дизайн", value: "0607"),
                .init(name: "Создание иллюстраций, рисунков", value: "0608"),
                .init(name: "3D дизайн и анимация", value: "0609"),
                .init(name: "Инфографика, дизайн презентаций", value: "0610"),
                .init(name: "Дизайн наружной рекламы, стендов, баннеров", value: "0611"),
                .init(name: "Дизайн - Другое", value: "0612"),
            ]),
            PerformersMainCategory(name: "Красота и здоровье, спорт",value: "0700", imageAddress: "categorySport",subCategories: [
                .init(name: "Массаж", value: "0701"),
                .init(name: "Парикмахерские услуги", value: "0702"),
                .init(name: "Макияж", value: "0703"),
                .init(name: "Косметология", value: "0704"),
                .init(name: "Уход за ногтями", value: "0705"),
                .init(name: "Услуги стилиста", value: "0706"),
                .init(name: "Уход за бровями и ресницами", value: "0707"),
                .init(name: "Депиляция", value: "0708"),
                .init(name: "Консультация диетолога", value: "0709"),
                .init(name: "Помощь персонального тренера", value: "0710"),
                .init(name: "Красота, здоровье, спорт - Другое", value: "0711"),
            ]),
            PerformersMainCategory(name: "Фото и видео",value: "0800", imageAddress: "categoryPhoto",subCategories: [
                .init(name: "Фотосъемка", value: "0801"),
                .init(name: "Видеосъемка", value: "0802"),
                .init(name: "Монтаж видео и аудио записей", value: "0803"),
                .init(name: "Обработка фотографий", value: "0804"),
                .init(name: "Оцифровка видео и фото", value: "0805"),
                .init(name: "Создание видеороликов", value: "0806"),
                .init(name: "Съемка при помощи дронов", value: "0807"),
                .init(name: "Фото и видео - Другое", value: "0808"),
            ]),
            PerformersMainCategory(name: "Репетиторы и обучение",value: "0900", imageAddress: "categoryEducation", subCategories: [
                .init(name: "Языковые репетиторы", value: "0901"),
                .init(name: "Подготовка к школе", value: "0902"),
                .init(name: "Подготовка к вступительным экзаменам в ВУЗ", value: "0903"),
                .init(name: "Преподавание на дому", value: "0904"),
                .init(name: "Услуги логопеда", value: "0905"),
                .init(name: "Обучение музыке", value: "0906"),
                .init(name: "Обучение танцам", value: "0907"),
                .init(name: "Спортивные тренеры", value: "0908"),
                .init(name: "Обучение вождению авто", value: "0909"),
                .init(name: "Обучение вождению мотоциклов", value: "0910"),
                .init(name: "Репетиторы и обучение - Другое", value: "0911"),
            ]),
            PerformersMainCategory(name: "Обслуживание и ремонт транспорта",value: "1000", imageAddress: "categoryRepairCar", subCategories: [
                .init(name: "Ремонт велосипедов", value: "1001"),
                .init(name: "Ремонт авто", value: "1002"),
                .init(name: "Ремонт мотоциклов", value: "1003"),
                .init(name: "Ремонт строительной техники", value: "1004"),
                .init(name: "Услуги шиномонтажника", value: "1005"),
                .init(name: "Мойка", value: "1006"),
                .init(name: "Химчистка салона", value: "1007"),
                .init(name: "Тюнинг авто и мотоциклов", value: "1008"),
                .init(name: "Кузовные работы", value: "1009"),
                .init(name: "Помощь на дороге", value: "1010"),
                .init(name: "Доставка топлива", value: "1011"),
                .init(name: "Техобслуживание и диагностика", value: "1012"),
                .init(name: "Эвакуация транспорта", value: "1013"),
                .init(name: "Обслуживание и ремонт транспорта - Другое", value: "1014"),
            ]),
            PerformersMainCategory(name: "Организация мероприятий и праздников",value: "1100", imageAddress: "categoryHoliday", subCategories: [
                .init(name: "Организация частных мероприятий и праздников", value: "1101"),
                .init(name: "Организация корпоративных мероприятий и праздников", value: "1102"),
                .init(name: "Организация свадебных мероприятий", value: "1103"),
                .init(name: "Услуги поваров", value: "1104"),
                .init(name: "Услуги бармена и баристы", value: "1105"),
                .init(name: "Услуги официантов", value: "1106"),
                .init(name: "Услуги музыкантов и музыкальное сопровождение", value: "1107"),
                .init(name: "Услуги ведущих мероприятия и аниматоров", value: "1108"),
                .init(name: "Организация мастер классов", value: "1109"),
                .init(name: "Организация банкетов, фуршетов, кейтеринг", value: "1110"),
                .init(name: "Дизайн и оформление мероприятий и праздников", value: "1111"),
                .init(name: "Организация мероприятий и праздников - Другое", value: "1112"),
            ]),
            PerformersMainCategory(name: "Профессиональная помощь",value: "1200", imageAddress: "categoryProfessionalHelp", subCategories: [
                .init(name: "Помощь юриста", value: "1201"),
                .init(name: "Помощь бухгалтера", value: "1202"),
                .init(name: "Консалтинговые услуги", value: "1203"),
                .init(name: "Личная охрана, охрана объектов, грузов", value: "1204"),
                .init(name: "Услуги риелтора", value: "1205"),
                .init(name: "Профессиональная помощь - Другое", value: "1206"),
            ]),
        ]
        categoriesArray.forEach({
            self.categories.updateValue($0, forKey: $0.value)
        })
    }
}
