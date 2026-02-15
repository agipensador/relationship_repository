#!/bin/bash
# Executa o app no ambiente PRODUÇÃO
echo "Running Love Relationship - PROD"
flutter run --flavor prod --target lib/main_prd.dart --release
