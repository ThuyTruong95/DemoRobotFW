import pandas as pd
import re
import requests
import time

from concurrent.futures import ThreadPoolExecutor
from typing import Dict

import unicodedata

# GRAPH_PARSER_URL = "https://gmap-api-gw.ghtklab.com/graph-address-parser/api/v1/graph-parse-address"
GRAPH_PARSER_URL = "https://graph-address-parser.ghtk.vn/api/v1/graph-parse-address"

def normalize(s: str) -> str:
    s = unicodedata.normalize("NFC", s)
    s = re.sub(r'[\u200B-\u200D\uFEFF]', '', s)
    return s.strip()


def send_request(row: Dict[str, str]):
    body = {
        "address": row["address"],
        "province": row["province"],
        "district": row["district"],
        "ward": row["ward"],
        "type": row["type"],
        "source": "api",
    }
    headers = {"Content-Type": "application/json",
               "request_id": "gmap_test"}
    try:
        start = time.perf_counter()  # bắt đầu tính thời gian
        response = requests.post(
            GRAPH_PARSER_URL, json=body, headers=headers, timeout=(6, 5)
        )
        row["elapsed_ms"] = (time.perf_counter() - start)  # toàn bộ thời gian (ms)
        row["http_elapsed_ms"] = response.elapsed.total_seconds()  # chỉ round-trip HTTP (ms)
        response.raise_for_status()
        data = response.json()
        if data:
            for addr in data:
                addrType = addr["type"]
                if addrType == 1:
                    name = "ward"
                elif addrType == 0:
                    name = "province"
                elif addrType in [3, 7]:
                    name = "district"
                else:
                    name = "hamlet"
                row["{}_name".format(name)] = addr["name"]
                row["{}_id".format(name)] = addr["gid"]

            if row["province_name"].lower() != row["province_name_expected"].lower():
                row["Result"] = "Not match province_name"
            elif row["district_name"].lower() != row["district_name_expected"].lower():
                row["Result"] = "Not match district_name"
            elif row["ward_name"].lower() != row["ward_name_expected"].lower():
                row["Result"] = "Not match ward_name"
            elif row["hamlet_name"].lower() != row["hamlet_name_expected"].lower():
                row["Result"] = "Not match hamlet_name"
            else:
                row["Result"] = "Pass"
        else:
            row["Result"] = "Fail"
    except Exception:
        print("Error when processing data {}".format(row))
    return 

def to_dict(row):
    data_dict = row.to_dict()
    data_dict["province_id"] = ""
    data_dict["province_name"] = ""
    data_dict["district_id"] = ""
    data_dict["district_name"] = ""
    data_dict["ward_id"] = ""
    data_dict["ward_name"] = ""
    data_dict["hamlet_id"] = ""
    data_dict["hamlet_name"] = ""
    row["elapsed_ms"] = ""
    row["http_elapsed_ms"] = ""
    data_dict["Result"] = ""
    return data_dict


if __name__ == "__main__":
    df = pd.read_excel(
        "data/Data_v9_api_2409.xlsx", sheet_name="Sheet1",dtype=str
    )
    # df = df[df["ward_new"].isna()]
    columns_to_keep = ["address", "province", "district", "ward","type","province_id_expected","province_name_expected","district_id_expected","district_name_expected","ward_id_expected","ward_name_expected","hamlet_id_expected","hamlet_name_expected"]
    df = df[columns_to_keep].fillna("")
    for col in columns_to_keep:
        df[col] = df[col].apply(lambda x : normalize(x))

    row_dicts = df.apply(lambda row: to_dict(row), axis=1).tolist()

    # Parameters
    MAX_WORKERS = 8  # parallel requests

    with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
        results = list(executor.map(send_request, row_dicts))

    df_result = pd.DataFrame(row_dicts)
    df_result.to_excel("parse_result_2509_prod_after_2.xlsx", index=False)
