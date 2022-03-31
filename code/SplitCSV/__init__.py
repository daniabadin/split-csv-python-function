import logging
import os
from io import BytesIO

import azure.functions as func
from azure.storage.blob import BlobServiceClient, __version__

def write_chunk(filename, part, lines, header, blob_service_client):

    filename_out = filename + '_part_'+ str("{:02d}".format(part)) +'.csv'

    with open(filename_out, 'wb') as f_out:
        f_out.write(header)
        f_out.writelines(lines)

    # Upload splitted csv to Azure Blob Storage on out path
    with open(filename_out,"rb") as blob_out:
        # Create a blob client using the local file name as the name for the blob
        filename_in_container='out/' + filename_out
        blob_client = blob_service_client.get_blob_client(container='csvs', blob=filename_in_container)

        logging.info("Uploading to Azure Storage as blob: " + filename_in_container)
        blob_client.upload_blob(blob_out.read())

    os.remove(filename_out)

def main(inputblob: func.InputStream):

    try:

        logging.info(f"Python blob trigger function processed blob \n"
                 f"File path: {inputblob.name}\n"
                 f"Blob Size: {inputblob.length} bytes")

        logging.info("Azure Blob Storage v" + __version__ + " - Python quickstart sample")
        
        filename = os.path.splitext(os.path.basename(inputblob.name))[0]
        logging.info("Filename without path and extension: " + filename)
        
        connect_str = os.getenv('storage_name')
        # Create the BlobServiceClient object which will be used to create a container client
        blob_service_client = BlobServiceClient.from_connection_string(connect_str)

        blob_bytes = inputblob.read()
        blob_to_read = BytesIO(blob_bytes)

        chunk_size=25000
        count = 0
        header = blob_to_read.readline()
        lines = []
        for line in blob_to_read.readlines():
            count += 1
            lines.append(line)
            if count % chunk_size == 0:
                write_chunk(filename, count // chunk_size, lines, header, blob_service_client)
                lines = []
        # write remainder
        if len(lines) > 0:
            write_chunk(filename, (count // chunk_size) + 1, lines, header, blob_service_client)
    except Exception as e:
        logging.error("Oops!", e.__class__, "occurred.")
        logging.error(e)

#########################################
#### TESTING ON LOCAL
#########################################

#### MUST BE EXECUTED FROM ROOT DIRECTORY, run py code/SplitCSV/__init__.py

# def write_chunk_local(filename, part, lines, header):

#     filename_out = filename + '_part_'+ str("{:02d}".format(part)) +'.csv'

#     with open('data/out/' + filename_out, 'wb') as f_out:
#         f_out.write(header)
#         f_out.writelines(lines)

# def main_local():
#     logging.info(f"Python blob trigger function processed blob")
    
#     file_path = "data/in/EMISIONES_HDCM.csv"
#     filename = os.path.splitext(os.path.basename(file_path))[0]
#     logging.info("Filename without path and extension: " + filename)

#     chunk_size = 25000

#     with open(file_path, "rb") as f:
#         count = 0
#         header = f.readline()
#         lines = []
#         for line in f:
#             count += 1
#             lines.append(line)
#             if count % chunk_size == 0:
#                 write_chunk_local(filename, count // chunk_size, lines, header)
#                 lines = []
#         # write remainder
#         if len(lines) > 0:
#             write_chunk_local(filename, (count // chunk_size) + 1, lines, header)

# main_local()