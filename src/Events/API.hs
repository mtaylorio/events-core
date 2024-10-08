{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
module Events.API
  ( module Events.API
  , module Events.API.Sessions
  , module Events.API.Topics
  ) where

import Data.Aeson
import Data.UUID
import Servant
import qualified Data.Aeson.KeyMap as KM

import Events.API.Helpers
import Events.API.Sessions
import Events.API.Topics
import Events.Event
import Events.Status


type API
  = SecureAPI
  :<|> StatusAPI


type StatusAPI
  = "status" :> Get '[JSON] StatusResponse


type SecureAPI
  = AuthProtect "signature-auth" :> ProtectedAPI


type ProtectedAPI
  = ( "sessions" :> SessionsAPI
  :<|> "topics" :> TopicsAPI
    )


type SessionsAPI
  = ( Get '[JSON] SessionsResponse
  :<|> Capture "session" UUID :> SessionAPI
    )


type SessionAPI
  = Get '[JSON] SessionResponse


type TopicsAPI
  = ( Get '[JSON] TopicsResponse
  :<|> ReqBody '[JSON] CreateTopic :> Post '[JSON] TopicResponse
  :<|> Capture "topic" UUID :> TopicAPI
    )


type TopicAPI
  = ( Get '[JSON] TopicResponse
  :<|> DeleteNoContent
  :<|> ReqBody '[JSON] UpdateTopic :> Put '[JSON] TopicResponse
  :<|> "events" :> EventsAPI
    )


type EventsAPI
  = ( ListAPI EventData
  :<|> ReqBody '[JSON] (KM.KeyMap Value) :> Post '[JSON] EventData
  :<|> Capture "event" UUID :> EventAPI
    )


type EventAPI
  = Get '[JSON] EventData
  :<|> DeleteNoContent
  :<|> ReqBody '[JSON] (KM.KeyMap Value) :> Post '[JSON] EventData
