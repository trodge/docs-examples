data "google_project" "project" {}

data "google_storage_project_service_account" "gcs_account" {}


resource "google_dataproc_metastore_service" "default" {
  service_id = "example-service-${local.name_suffix}"
  location   = "us-central1"

  encryption_config {
    kms_key = google_kms_crypto_key.crypto_key.id
  }

  hive_metastore_config {
    version = "3.1.2"
  }

  depends_on = [google_kms_crypto_key_iam_binding.crypto_key_binding]
}

resource "google_kms_crypto_key" "crypto_key" {
  name     = "example-key-${local.name_suffix}"
  key_ring = google_kms_key_ring.key_ring.id

  purpose  = "ENCRYPT_DECRYPT"
}

resource "google_kms_key_ring" "key_ring" {
  name     = "example-keyring-${local.name_suffix}"
  location = "us-central1"
}

resource "google_kms_crypto_key_iam_binding" "crypto_key_binding" {
  crypto_key_id = google_kms_crypto_key.crypto_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:service-${data.google_project.project.number}@gcp-sa-metastore.iam.gserviceaccount.com",
    "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
  ]
}
