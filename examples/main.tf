module "eks_bootstrap" {
  source             = "../"
  aws_default_region = "eu-west-1"
  cluster            = { name = "test"}
  vpc_id             = "1234"
  subnet_ids         = ["1234", "5678"]
}
