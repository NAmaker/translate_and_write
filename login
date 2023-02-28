import time
from selenium import webdriver
from selenium.webdriver.common.by import By
import os


def get_webdriver_location():
    for i, j, k in os.walk("E:"):
        for path in k:
            if path == "chromedriver_110.exe":
                path = os.path.join(i, path)
                print(path)
    return path


def to_str(lis):
    res = ''.join(lis)
    return res


def get_str_result_and_send(setr, lis):
    for i in setr:
        if i.text:
            i = str(i.text).replace("\n", "")
            lis.append(i)


class translate(object):
    # 所有的结果,列表里面是单次的结果
    dict = {}
    r_result = []
    r_details = []
    r_examples = []

    xpath_list = {
        # 登录
        'login_ad': '//*[@id="app-guide"]/div/div/div[2]/span',
        # 输入
        'text_input': '//*[@id="baidu_translate_input"]',
        # 结果
        'translate_result': '/html/body/div[1]/div[2]/div/div/div[1]/div[2]/div[1]/div[2]/div/div/div[1]/p[2]',
        # 确认
        'js_get': 'document.getElementsByClassName("trans-btn trans-btn-zh").click',
        # 详细介绍
        'detail_resu_classnames':'dictionary-comment',
        # 双语例句
        'example_sentences_classnames': 'double-sample',
        # 发音
        'pronunciation-button': '//*[@id="main-outer"]/div/div/div[1]/div[2]/div[1]/div[1]/div/div[2]/div[3]/a/span',
    }

    def __init__(self):
        bro = webdriver.Chrome(executable_path='E:desktop\chromedriver_win32\chromedriver_110.exe')
        bro.get("https://fanyi.baidu.com/")
        self.bro = bro
        self.bro.maximize_window()
        self.xpath_click(self.xpath_list['login_ad'])
        time.sleep(0.5)

    def js_locate_and_click(self, js_xpath):
        self.bro.execute_script(js_xpath)

    def to_str(self,lis):
        res = ''.join(lis)
        return res

    def js_action(self, js):
        time.sleep(0.5)
        self.bro.execute_script(js)

    def locate_class_names(self,name):
        return self.bro.find_elements(By.CLASS_NAME,name)

    def locate_xpath(self, xpath):
        time.sleep(1)
        return self.bro.find_element(By.XPATH, xpath)

    def locate_xpaths(self, xpaths):
        return self.bro.find_elements(By.XPATH, xpaths)

    def xpath_click(self, xpath):
        self.locate_xpath(xpath).click()

    def txt_input(self, xpath, txt):
        self.locate_xpath(xpath).send_keys(txt)

    def close(self):
        self.bro.close()

    def clear(self,xpath):
        self.locate_xpath(xpath).clear()

    # 返回单次结果
    def action(self, word):
        # 打包单次的数据
        # 推荐这个方法
        r_result = []
        r_details = []
        r_examples = []
        self.txt_input(self.xpath_list['text_input'], word)
        self.js_locate_and_click(self.xpath_list['js_get'])
        time.sleep(1)
        s = self.locate_xpath(self.xpath_list['translate_result']).text
        details = self.locate_class_names(self.xpath_list['detail_resu_classnames'])
        examples = self.locate_class_names(self.xpath_list['example_sentences_classnames'])
        time.sleep(0.5)
        r_result.append(s)
        get_str_result_and_send(details,r_details)
        get_str_result_and_send(examples, r_examples)
        all = [r_result, r_details, r_examples]
        # 将这次数据打包传给dict存储
        self.dict[s] = all
        self.clear(self.xpath_list['text_input'])
        return r_result,r_details,r_examples

    # 全部结果
    def action2(self, word):
        self.txt_input(self.xpath_list['text_input'], word)
        self.js_locate_and_click(self.xpath_list['js_get'])
        time.sleep(0.5)
        s = self.locate_xpath(self.xpath_list['translate_result']).text
        details = self.locate_class_names(self.xpath_list['detail_resu_classnames'])
        examples = self.locate_class_names(self.xpath_list['example_sentences_classnames'])
        self.r_result.append(s)
        get_str_result_and_send(details, self.r_details)
        get_str_result_and_send(examples, self.r_examples)
        self.clear(self.xpath_list['text_input'])
